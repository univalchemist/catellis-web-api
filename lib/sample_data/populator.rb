module SampleData
  class Populator
    def call(restaurant_count: 2)
      restaurant_count.times.each do |name|
        restaurant = FactoryBot.create(
          :restaurant,
          rest_open_at: '10:00',
          rest_close_at: '23:00',
        )

        restaurant_builder = RestaurantBuilder.new
        restaurant_builder.call(restaurant)
      end
    end
  end

  class RestaurantBuilder
    def call(restaurant)
      floor_plan_range = (3..3)
      floor_plan_table_range = (12..12)

      restarant_open_time_range = restaurant.rest_open_at.hour..(restaurant.rest_close_at.hour - 1)

      # Owner/employees
      FactoryBot.create(
        :user,
        :restaurant_owner,
        :roleaware_ordinal_email,
        restaurant: restaurant,
      )
      FactoryBot.create_list(
        :user,
        2,
        :restaurant_employee,
        :roleaware_ordinal_email,
        restaurant: restaurant
      )

      # Customers
      customers = FactoryBot.create_list(
        :customer,
        30,
        :random_customer,
        restaurant: restaurant
      )

      # Reservations
      reservation_count = 15
      date = Time.zone.now.beginning_of_day - 1.day
      date_end = date + 14.days
      while date <= date_end
        reservation_count.times.each do |_|
          # Must adjust the reservation based on the restaurant's local timezone.
          reservation_hour = (
            (rand(restarant_open_time_range) - restaurant.local_timezone.utc_offset / 1.hour).hour + [0, 0.25, 0.5, 0.75].sample.hour
          )

          FactoryBot.create(
            :reservation,
            restaurant: restaurant,
            customer: customers.sample,
            scheduled_start_at: date.beginning_of_day + reservation_hour
          )
        end

        date = date + 1.day
      end

      # Floor plans and tables
      floor_plan_dining_room = create_floor_plan(
        restaurant: restaurant,
        name: 'Dining Room',
        table_count: 12,
        table_size: 4,
        table_number_start: FloorPlanTable.includes(:floor_plan).where(floor_plans: {restaurant: restaurant}).count
      )
      floor_plan_patio = create_floor_plan(
        restaurant: restaurant,
        name: 'Patio',
        table_count: 9,
        table_size: 4,
        table_number_start: FloorPlanTable.includes(:floor_plan).where(floor_plans: {restaurant: restaurant}).count
      )
      floor_plan_valentines = create_floor_plan(
        restaurant: restaurant,
        name: 'Valentines Day',
        table_count: 16,
        table_size: 2,
        table_number_start: 0
      )

      # Reservation plans
      # FIXME: these should be using the new wrapping range support
      @rsvp_plan_summer_weekday_lunch = FactoryBot.create(
        :reservation_plan,
        restaurant: restaurant,
        name: "Summer Weekday Lunch",
        effective_time_start_at: '10:00',
        effective_time_end_at: '14:00',
        cust_reservable_start_at: '11:00',
        cust_reservable_end_at: '13:00',
        repeat: :annually,
        active_weekday_0: false,
        active_weekday_1: true,
        active_weekday_2: true,
        active_weekday_3: true,
        active_weekday_4: true,
        active_weekday_5: false,
        active_weekday_6: false,
        effective_date_start_at: DateTime.new(2000, 4, 1).beginning_of_day,
        effective_date_end_at: DateTime.new(2000, 9, 30).end_of_day,
        floor_plans: [floor_plan_dining_room, floor_plan_patio],
      )
      @rsvp_plan_summer_weekday_dinner = FactoryBot.create(
        :reservation_plan,
        restaurant: restaurant,
        name: "Summer Weekday Dinner",
        effective_time_start_at: '15:00',
        effective_time_end_at: '23:00',
        cust_reservable_start_at: '17:00',
        cust_reservable_end_at: '22:00',
        repeat: :annually,
        active_weekday_0: false,
        active_weekday_1: true,
        active_weekday_2: true,
        active_weekday_3: true,
        active_weekday_4: true,
        active_weekday_5: false,
        active_weekday_6: false,
        effective_date_start_at: DateTime.new(2000, 4, 1).beginning_of_day,
        effective_date_end_at: DateTime.new(2000, 9, 30).end_of_day,
        floor_plans: [floor_plan_dining_room, floor_plan_patio],
      )
      @rsvp_plan_summer_weekend_lunch = FactoryBot.create(
        :reservation_plan,
        restaurant: restaurant,
        name: "Summer Weekend Lunch",
        effective_time_start_at: '10:00',
        effective_time_end_at: '14:00',
        cust_reservable_start_at: '11:00',
        cust_reservable_end_at: '13:00',
        repeat: :annually,
        active_weekday_0: true,
        active_weekday_1: false,
        active_weekday_2: false,
        active_weekday_3: false,
        active_weekday_4: false,
        active_weekday_5: true,
        active_weekday_6: true,
        effective_date_start_at: DateTime.new(2000, 4, 1).beginning_of_day,
        effective_date_end_at: DateTime.new(2000, 9, 30).end_of_day,
        floor_plans: [floor_plan_dining_room, floor_plan_patio],
      )
      @rsvp_plan_summer_weekend_dinner = FactoryBot.create(
        :reservation_plan,
        restaurant: restaurant,
        name: "Summer Weekend Dinner",
        effective_time_start_at: '15:00',
        effective_time_end_at: '23:00',
        cust_reservable_start_at: '17:00',
        cust_reservable_end_at: '22:00',
        repeat: :annually,
        active_weekday_0: true,
        active_weekday_1: false,
        active_weekday_2: false,
        active_weekday_3: false,
        active_weekday_4: false,
        active_weekday_5: true,
        active_weekday_6: true,
        effective_date_start_at: DateTime.new(2000, 4, 1).beginning_of_day,
        effective_date_end_at: DateTime.new(2000, 9, 30).end_of_day,
        floor_plans: [floor_plan_dining_room, floor_plan_patio],
      )

      @rsvp_plan_winter_weekday_lunch = FactoryBot.create(
        :reservation_plan,
        restaurant: restaurant,
        name: "Winter Weekday Lunch",
        effective_time_start_at: '10:00',
        effective_time_end_at: '14:00',
        cust_reservable_start_at: '11:00',
        cust_reservable_end_at: '13:00',
        repeat: :annually,
        active_weekday_0: false,
        active_weekday_1: true,
        active_weekday_2: true,
        active_weekday_3: true,
        active_weekday_4: true,
        active_weekday_5: false,
        active_weekday_6: false,
        effective_date_start_at: DateTime.new(2000, 10, 1).beginning_of_day,
        effective_date_end_at: DateTime.new(2001, 3, 30).end_of_day,
        floor_plans: [floor_plan_dining_room],
      )
      @rsvp_plan_winter_weekday_dinner = FactoryBot.create(
        :reservation_plan,
        restaurant: restaurant,
        name: "Winter Weekday Dinner",
        effective_time_start_at: '15:00',
        effective_time_end_at: '23:00',
        cust_reservable_start_at: '17:00',
        cust_reservable_end_at: '22:00',
        repeat: :annually,
        active_weekday_0: false,
        active_weekday_1: true,
        active_weekday_2: true,
        active_weekday_3: true,
        active_weekday_4: true,
        active_weekday_5: false,
        active_weekday_6: false,
        effective_date_start_at: DateTime.new(2000, 10, 1).beginning_of_day,
        effective_date_end_at: DateTime.new(2001, 3, 30).end_of_day,
        floor_plans: [floor_plan_dining_room],
      )

      @rsvp_plan_winter_weekend_lunch = FactoryBot.create(
        :reservation_plan,
        restaurant: restaurant,
        name: "Winter Weekend Lunch",
        effective_time_start_at: '10:00',
        effective_time_end_at: '14:00',
        cust_reservable_start_at: '11:00',
        cust_reservable_end_at: '13:00',
        repeat: :annually,
        active_weekday_0: true,
        active_weekday_1: false,
        active_weekday_2: false,
        active_weekday_3: false,
        active_weekday_4: false,
        active_weekday_5: true,
        active_weekday_6: true,
        effective_date_start_at: DateTime.new(2000, 10, 1).beginning_of_day,
        effective_date_end_at: DateTime.new(2001, 3, 30).end_of_day,
        floor_plans: [floor_plan_dining_room],
      )
      @rsvp_plan_winter_weekend_dinner = FactoryBot.create(
        :reservation_plan,
        restaurant: restaurant,
        name: "Winter Weekend Dinner",
        effective_time_start_at: '15:00',
        effective_time_end_at: '23:00',
        cust_reservable_start_at: '17:00',
        cust_reservable_end_at: '22:00',
        repeat: :annually,
        active_weekday_0: true,
        active_weekday_1: false,
        active_weekday_2: false,
        active_weekday_3: false,
        active_weekday_4: false,
        active_weekday_5: true,
        active_weekday_6: true,
        effective_date_start_at: DateTime.new(2000, 10, 1).beginning_of_day,
        effective_date_end_at: DateTime.new(2001, 3, 30).end_of_day,
        floor_plans: [floor_plan_dining_room],
      )

      @rsvp_plan_valentines = FactoryBot.create(
        :reservation_plan,
        restaurant: restaurant,
        name: "Valentine's Day",
        effective_time_start_at: '10:00',
        effective_time_end_at: '23:00',
        cust_reservable_start_at: '11:30',
        cust_reservable_end_at: '21:30',
        priority: 200,
        repeat: :annually,
        effective_date_start_at: DateTime.new(2000, 02, 14).beginning_of_day,
        effective_date_end_at: DateTime.new(2000, 02, 14).end_of_day,
        floor_plans: [floor_plan_valentines],
      )
    end

    def create_floor_plan(
      restaurant:,
      name:,
      table_count: 12,
      table_size: 4,
      table_number_start: 0
    )
      floor_plan_table_col_length = Math::sqrt(table_count).ceil

      floor_plan = FactoryBot.create(
        :floor_plan,
        restaurant: restaurant,
        name: name
      )

      current_table_number = table_number_start
      table_count.times do |fpt_n|
        current_table_number = current_table_number + 1
        floor_plan_table = FactoryBot.create(
          :floor_plan_table,
          floor_plan: floor_plan,
          x: 130 + 140 * (floor_plan.floor_plan_tables.count % floor_plan_table_col_length),
          y: 10 + 140 * ((floor_plan.floor_plan_tables.count / floor_plan_table_col_length).floor + 1),
          table_number: current_table_number,
          table_size: table_size
        )
      end

      floor_plan
    end
  end
end
