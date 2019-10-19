module Resolvers
  module ReservationPlans
    def self.build_args(raw_args)
      clean_args = raw_args.slice(
        :name,
        :repeat,
        :priority,
        :effective_time_start_at,
        :effective_time_end_at,
        :cust_reservable_start_at,
        :cust_reservable_end_at,
        :active_weekday_0,
        :active_weekday_1,
        :active_weekday_2,
        :active_weekday_3,
        :active_weekday_4,
        :active_weekday_5,
        :active_weekday_6,
        :effective_date_start_at,
        :effective_date_end_at,
        :reservation_plan_floor_plans_attributes,
      )

      unless clean_args[:reservation_plan_floor_plans_attributes].nil?
        clean_args[:reservation_plan_floor_plans_attributes] = clean_args[:reservation_plan_floor_plans_attributes].map do |attrs|
          attrs.slice(
            :id,
            :floor_plan_id,
            :_destroy,
          )
        end
      end

      unless clean_args[:repeat] == 'none'
        raw_start_at = DateTime.parse(clean_args[:effective_date_start_at])
        raw_end_at = DateTime.parse(clean_args[:effective_date_end_at])

        normalized_start_at = DateTime.new(2000, raw_start_at.month, raw_start_at.day)
        normalized_end_at = DateTime.new(2000, raw_end_at.month, raw_end_at.day)
        clean_args[:effective_date_start_at] = normalized_start_at
        clean_args[:effective_date_end_at] = normalized_end_at
      end

      clean_args
    end
  end
end
