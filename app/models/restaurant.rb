class Restaurant < ApplicationRecord
  acts_as_paranoid
  resourcify

  has_many :reservations

  def local_timezone
    Timezone[self.timezone_name]
  end

  (1..20).to_a.each do |num|
    define_method("turn_time_#{num}") do
      self["turn_time_#{num}"].to_s
    end

    define_method("turn_time_#{num}=") do |v|
      write_attribute("turn_time_#{num}", v.to_f) if v.present?
    end
  end

  def get_todays_reservations
    reservations.where(scheduled_start_at: Time.now.beginning_of_day..Time.now.end_of_day)
  end

  def get_a_days_reservations(utc_start,utc_end)
    reservations.where(scheduled_start_at: utc_start..utc_end)
  end

  def get_available_times(party_size, start_at, end_at=nil)
    restaurant = self
    restaurant_timezone = restaurant.local_timezone

    search_start_at = DateTime.parse(start_at).beginning_of_day
    search_end_at = DateTime.parse(start_at).end_of_day

    utc_start_at = restaurant_timezone.local_to_utc(search_start_at)
    utc_end_at = restaurant_timezone.local_to_utc(search_end_at)
    reservations = restaurant.get_a_days_reservations(utc_start_at,utc_end_at).order(scheduled_start_at: :asc) #.order(party_size: :desc)

    unless end_at.nil?
      search_end_at = DateTime.parse(end_at)
    else
      search_end_at = search_start_at.end_of_day
    end

    service = ::ReservationPlans::ReservationPlanRangeCalculator.new
    results = service.perform(
      restaurant: restaurant,
      search_start_at: search_start_at,
      search_end_at: search_end_at,
    )

    times = []
    results.entries.each do |date, reservation_plans|
      reservation_plans.each do |reservation_plan|
        plan_cust_start_time = DateTime.new(
          date.year,
          date.month,
          date.day,
          reservation_plan.cust_reservable_start_at.hour,
          reservation_plan.cust_reservable_start_at.min,
        )
        plan_cust_end_time = DateTime.new(
          date.year,
          date.month,
          date.day,
          reservation_plan.cust_reservable_end_at.hour,
          reservation_plan.cust_reservable_end_at.min,
        )

        matches = {}
        available_tables_for_time = {}

        tables_association = reservation_plan.floor_plans.first.floor_plan_tables.not_blocked.order(max_covers: :asc)

        current_time = plan_cust_start_time
        while current_time <= plan_cust_end_time
          utc_time = restaurant_timezone.local_to_utc(current_time)
          matches[utc_time.to_s] = {
            reservations_to_tables: {},
            tables_to_reservations: {}
          }
          tables = tables_association.dup.to_a

          reservations.each do |res|
            if res.is_time_during_reservation?(utc_time)
              tables.each do |table|
                if res.party_size >= table.min_covers && res.party_size <= table.max_covers
                  matches[utc_time.to_s][:reservations_to_tables][res.id] = table
                  matches[utc_time.to_s][:tables_to_reservations][table.id] = res
                  tables.delete(table)
                  break
                end
              end
            end
          end

          current_time = current_time + 15.minutes
        end

        tables = tables_association.dup.to_a
        tables_with_capacity_for_party = []

        tables.each do |table|
          if party_size.between?(table.min_covers, table.max_covers)
            tables_with_capacity_for_party << table
          end
        end

        current_time = plan_cust_start_time
        if tables_with_capacity_for_party.length > 0
          max_covers_capacity = tables_with_capacity_for_party.sum(&:max_covers)
          while current_time <= plan_cust_end_time
            max_covers = max_covers_capacity
            covers_seating = 0
            utc_time = restaurant_timezone.local_to_utc(current_time)

            reservations.each do |res|
              if res.is_time_during_reservation_or_lead_in_time?(utc_time, party_size)
                table = matches[res.scheduled_start_at.to_s][:reservations_to_tables][res.id]
                max_covers = max_covers - table.max_covers if table
                if res.is_time_at_start?(utc_time)
                  covers_seating += res.party_size
                end
              end
            end

            matches[utc_time.to_s][:reservations_to_tables].each do |table|
              puts "current_time: #{current_time}, res_party_size: #{matches[utc_time.to_s][:tables_to_reservations][table[1].id].scheduled_start_at}, table_covers: #{table[1].max_covers}"
            end

            new_party_plus_covers_seating = covers_seating + party_size

            if party_size <= max_covers && new_party_plus_covers_seating <= restaurant.kitchen_pacing
              times << utc_time
            end

            current_time = current_time + 15.minutes
          end
        end
      end
    end
    
    return times.map(&:iso8601)
  end
end
