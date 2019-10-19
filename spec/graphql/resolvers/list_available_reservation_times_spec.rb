require 'rails_helper'

RSpec.describe Resolvers::ListAvailableReservationTimes, type: :feature do
  def service_instance
    described_class.new
  end

  before(:each) do
    @restaurant = create(:restaurant)
  end

  describe "retrieves reservation plans as guest" do
    before(:each) do
      @reservation_plan_lunch = create(
        :reservation_plan,
        restaurant: @restaurant,
        name: 'Lunch',
        effective_time_start_at: '12:00',
        effective_time_end_at: '13:00',
        cust_reservable_start_at: '12:00',
        cust_reservable_end_at: '13:00',
        repeat: :annually,
        effective_date_start_at: DateTime.new(2000, 01, 1).beginning_of_day,
        effective_date_end_at: DateTime.new(2000, 12, 31).end_of_day,
      )

      @reservation_plan_dinner = create(
        :reservation_plan,
        restaurant: @restaurant,
        name: 'Dinner',
        effective_time_start_at: '17:00',
        effective_time_end_at: '18:00',
        cust_reservable_start_at: '17:00',
        cust_reservable_end_at: '18:00',
        repeat: :annually,
        effective_date_start_at: DateTime.new(2000, 01, 1).beginning_of_day,
        effective_date_end_at: DateTime.new(2000, 12, 31).end_of_day,
      )
    end

    it "works for a single day" do
      args = {
        restaurant_id: @restaurant.id,
        search_start_at: DateTime.new(2018, 5, 14).beginning_of_day.iso8601,
        search_end_at: DateTime.new(2018, 5, 14).end_of_day.iso8601,
      }
      ctx = {
      }

      result = service_instance.call({}, args, ctx)

      restaurant_timezone = @restaurant.local_timezone
      expect(result).to eq ([
        restaurant_timezone.local_to_utc(DateTime.new(2018, 5, 14, 12, 00)).iso8601,
        restaurant_timezone.local_to_utc(DateTime.new(2018, 5, 14, 12, 15)).iso8601,
        restaurant_timezone.local_to_utc(DateTime.new(2018, 5, 14, 12, 30)).iso8601,
        restaurant_timezone.local_to_utc(DateTime.new(2018, 5, 14, 12, 45)).iso8601,
        restaurant_timezone.local_to_utc(DateTime.new(2018, 5, 14, 13, 00)).iso8601,
        restaurant_timezone.local_to_utc(DateTime.new(2018, 5, 14, 17, 00)).iso8601,
        restaurant_timezone.local_to_utc(DateTime.new(2018, 5, 14, 17, 15)).iso8601,
        restaurant_timezone.local_to_utc(DateTime.new(2018, 5, 14, 17, 30)).iso8601,
        restaurant_timezone.local_to_utc(DateTime.new(2018, 5, 14, 17, 45)).iso8601,
        restaurant_timezone.local_to_utc(DateTime.new(2018, 5, 14, 18, 00)).iso8601,
      ])
    end
  end
end
