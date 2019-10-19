require 'rails_helper'

RSpec.describe ReservationPlans::ReservationPlanRangeCalculator, type: :feature do
  def service_instance
    described_class.new
  end

  before(:each) do
    @restaurant = create(:restaurant)
    @user = create(:user, :restaurant_employee, restaurant: @restaurant)
  end

  def perform_test(search_start_at:, search_end_at: search_start_at, expected_results:)
    results = service_instance.perform(
      restaurant: @restaurant,
      search_start_at: search_start_at,
      search_end_at: search_end_at,
    )

    expect(results).to eq expected_results
  end

  describe "Valentine's day" do
    before(:each) do
      @reservation_plan_valentines = create(
        :reservation_plan,
        restaurant: @restaurant,
        effective_time_start_at: '10:00',
        effective_time_end_at: '23:00',
        cust_reservable_start_at: '11:30',
        cust_reservable_end_at: '21:30',
        priority: 200,
        repeat: :annually,
        effective_date_start_at: DateTime.new(2000, 02, 14).beginning_of_day,
        effective_date_end_at: DateTime.new(2000, 02, 14).end_of_day,
      )
      @reservation_plan_normal = create(
        :reservation_plan,
        restaurant: @restaurant,
        effective_time_start_at: '10:00',
        effective_time_end_at: '23:00',
        cust_reservable_start_at: '11:30',
        cust_reservable_end_at: '21:30',
        repeat: :annually,
        effective_date_start_at: DateTime.new(2000, 01, 1).beginning_of_day,
        effective_date_end_at: DateTime.new(2000, 12, 31).end_of_day,
      )
    end

    it "finds multiple days over summer/winter transition" do
      perform_test(
        search_start_at: DateTime.new(2018, 2, 13),
        search_end_at: DateTime.new(2018, 2, 15),
        expected_results: {
          DateTime.new(2018, 2, 13) => [@reservation_plan_normal],
          DateTime.new(2018, 2, 14) => [@reservation_plan_valentines],
          DateTime.new(2018, 2, 15) => [@reservation_plan_normal],
        }
      )
    end
  end

  describe "All week - lunch, dinner" do
    before(:each) do
      @reservation_plan_lunch = create(
        :reservation_plan,
        restaurant: @restaurant,
        effective_time_start_at: '10:00',
        effective_time_end_at: '14:00',
        cust_reservable_start_at: '11:00',
        cust_reservable_end_at: '13:00',
        repeat: :annually,
        effective_date_start_at: DateTime.new(2000, 1, 1).beginning_of_day,
        effective_date_end_at: DateTime.new(2000, 12, 31).end_of_day,
      )
      @reservation_plan_dinner = create(
        :reservation_plan,
        restaurant: @restaurant,
        effective_time_start_at: '15:00',
        effective_time_end_at: '23:00',
        cust_reservable_start_at: '17:00',
        cust_reservable_end_at: '12:00',
        repeat: :annually,
        effective_date_start_at: DateTime.new(2000, 1, 1).beginning_of_day,
        effective_date_end_at: DateTime.new(2000, 12, 31).end_of_day,
      )
    end

    it "finds lunch and dinner for 1 Jun 2018" do
      perform_test(
        search_start_at: DateTime.new(2018, 6, 1),
        search_end_at: DateTime.new(2018, 6, 1),
        expected_results: {
          DateTime.new(2018, 6, 1) => [@reservation_plan_lunch, @reservation_plan_dinner],
        }
      )
    end

    it "finds lunch and dinner for week of 13 May 2018" do
      expected_results = (13..19).inject({}) do |memo, x|
        memo[DateTime.new(2018, 5, x)] = [@reservation_plan_lunch, @reservation_plan_dinner]

        memo
      end

      perform_test(
        search_start_at: DateTime.new(2018, 5, 13),
        search_end_at: DateTime.new(2018, 5, 19),
        expected_results: expected_results
      )
    end

    it "finds lunch and dinner for month of May 2018" do
      expected_results = (1..31).inject({}) do |memo, x|
        memo[DateTime.new(2018, 5, x)] = [@reservation_plan_lunch, @reservation_plan_dinner]

        memo
      end

      perform_test(
        search_start_at: DateTime.new(2018, 5, 1),
        search_end_at: DateTime.new(2018, 5, 31),
        expected_results: expected_results
      )
    end
  end

  describe "All week, all day, summer, winter" do
    before(:each) do
      @summer_start_at = DateTime.new(2000, 4, 1)
      @summer_end_at = DateTime.new(2000, 9, 30)

      @winter_start_at = DateTime.new(2000, 10, 1)
      @winter_end_at = DateTime.new(2001, 3, 31)

      # Summer, covered by a single range of 1 Apr - 30 Sep
      @reservation_plan_summer = create(
        :reservation_plan,
        restaurant: @restaurant,
        effective_time_start_at: '10:00',
        effective_time_end_at: '23:00',
        cust_reservable_start_at: '11:30',
        cust_reservable_end_at: '21:30',
        repeat: :annually,
        effective_date_start_at: @summer_start_at.beginning_of_day,
        effective_date_end_at: @summer_end_at.end_of_day,
      )

      # Winter, covered by (wrapping) range of 1 Oct - 30 Mar
      @reservation_plan_winter = create(
        :reservation_plan,
        restaurant: @restaurant,
        effective_time_start_at: '10:00',
        effective_time_end_at: '23:00',
        cust_reservable_start_at: '11:30',
        cust_reservable_end_at: '21:30',
        repeat: :annually,
        effective_date_start_at: @winter_start_at.beginning_of_day,
        effective_date_end_at: @winter_end_at.end_of_day,
      )
    end

    it "finds multiple days in 'summer'" do
      expected_results = (1..3).inject({}) do |memo, x|
        memo[DateTime.new(2018, 5, x)] = [@reservation_plan_summer]

        memo
      end

      perform_test(
        search_start_at: DateTime.new(2018, 5, 1),
        search_end_at: DateTime.new(2018, 5, 3),
        expected_results: expected_results
      )
    end

    it "finds multiple days in 'winter'" do
      expected_results = (1..3).inject({}) do |memo, x|
        memo[DateTime.new(2018, 11, x)] = [@reservation_plan_winter]

        memo
      end

      perform_test(
        search_start_at: DateTime.new(2018, 11, 1),
        search_end_at: DateTime.new(2018, 11, 3),
        expected_results: expected_results
      )
    end

    it "finds multiple days over summer/winter transition" do
      perform_test(
        search_start_at: DateTime.new(2018, 9, 29),
        search_end_at: DateTime.new(2018, 10, 2),
        expected_results: {
          DateTime.new(2018, 9, 29) => [@reservation_plan_summer],
          DateTime.new(2018, 9, 30) => [@reservation_plan_summer],
          DateTime.new(2018, 10, 1) => [@reservation_plan_winter],
          DateTime.new(2018, 10, 2) => [@reservation_plan_winter],
        }
      )
    end

    it "finds multiple days over winter/summer transition" do
      perform_test(
        search_start_at: DateTime.new(2018, 3, 29),
        search_end_at: DateTime.new(2018, 4, 2),
        expected_results: {
          DateTime.new(2018, 3, 29) => [@reservation_plan_winter],
          DateTime.new(2018, 3, 30) => [@reservation_plan_winter],
          DateTime.new(2018, 3, 31) => [@reservation_plan_winter],
          DateTime.new(2018, 4, 1) => [@reservation_plan_summer],
          DateTime.new(2018, 4, 2) => [@reservation_plan_summer],
        }
      )
    end

    it "finds multiple days over winter year-wrap transition" do
      perform_test(
        search_start_at: DateTime.new(2018, 12, 31),
        search_end_at: DateTime.new(2019, 1, 1),
        expected_results: {
          DateTime.new(2018, 12, 31) => [@reservation_plan_winter],
          DateTime.new(2019, 1, 1) => [@reservation_plan_winter],
        }
      )
    end
  end

  describe "Weekday (Tu/We/Th) and Weekend (Fr/Sa/Su), closed Monday - all day, all year" do
    before(:each) do
      @reservation_plan_weekday = create(
        :reservation_plan,
        restaurant: @restaurant,
        effective_time_start_at: '10:00',
        effective_time_end_at: '23:00',
        cust_reservable_start_at: '11:30',
        cust_reservable_end_at: '21:30',
        repeat: :annually,
        active_weekday_0: false,
        active_weekday_1: false,
        active_weekday_2: true,
        active_weekday_3: true,
        active_weekday_4: true,
        active_weekday_5: false,
        active_weekday_6: false,
        effective_date_start_at: DateTime.new(2000, 1, 1).beginning_of_day,
        effective_date_end_at: DateTime.new(2000, 12, 31).end_of_day,
      )

      @reservation_plan_weekend = create(
        :reservation_plan,
        restaurant: @restaurant,
        effective_time_start_at: '10:00',
        effective_time_end_at: '23:00',
        cust_reservable_start_at: '11:30',
        cust_reservable_end_at: '21:30',
        repeat: :annually,
        active_weekday_0: true,
        active_weekday_1: false,
        active_weekday_2: false,
        active_weekday_3: false,
        active_weekday_4: false,
        active_weekday_5: true,
        active_weekday_6: true,
        effective_date_start_at: DateTime.new(2000, 1, 1).beginning_of_day,
        effective_date_end_at: DateTime.new(2000, 12, 31).end_of_day,
      )
    end

    it "finds accurate plans for week starting on Sunday" do
      perform_test(
        search_start_at: DateTime.new(2018, 4, 1),
        search_end_at: DateTime.new(2018, 4, 7),
        expected_results: {
          DateTime.new(2018, 4, 1) => [@reservation_plan_weekend],
          DateTime.new(2018, 4, 2) => [],
          DateTime.new(2018, 4, 3) => [@reservation_plan_weekday],
          DateTime.new(2018, 4, 4) => [@reservation_plan_weekday],
          DateTime.new(2018, 4, 5) => [@reservation_plan_weekday],
          DateTime.new(2018, 4, 6) => [@reservation_plan_weekend],
          DateTime.new(2018, 4, 7) => [@reservation_plan_weekend],
        }
      )
    end
  end
end
