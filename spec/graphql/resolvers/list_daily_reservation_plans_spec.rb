require 'rails_helper'

RSpec.describe Resolvers::ListDailyReservationPlans, type: :feature do
  def service_instance
    described_class.new
  end

  def result_struct_builder(date_time, reservation_plans)
    Resolvers::ListDailyReservationPlans::DailyReservationPlanList.new(
      date_time,
      date_time,
      reservation_plans
    )
  end

  before(:each) do
    @restaurant = create(:restaurant)
    @user = create(:user, :restaurant_employee, restaurant: @restaurant)
  end

  describe "retrieves reservation plans" do
    before(:each) do
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

    it "works for just a search start date" do
      args = {
        search_start_at: DateTime.new(2018, 5, 14).iso8601,
        search_end_at: DateTime.new(2018, 5, 14).iso8601,
      }
      ctx = {
        current_user: @user
      }

      result = service_instance.call({}, args, ctx)

      expect(result).to eq ([
        result_struct_builder(
          DateTime.new(2018, 5, 14),
          [@reservation_plan_normal]
        ),
      ])
    end

    it "works for a search range" do
      args = {
        search_start_at: DateTime.new(2018, 5, 14).iso8601,
        search_end_at: DateTime.new(2018, 5, 16).iso8601,
      }
      ctx = {
        current_user: @user
      }

      result = service_instance.call({}, args, ctx)

      expect(result).to eq ([
        result_struct_builder(
          DateTime.new(2018, 5, 14),
          [@reservation_plan_normal]
        ),
        result_struct_builder(
          DateTime.new(2018, 5, 15),
          [@reservation_plan_normal]
        ),
        result_struct_builder(
          DateTime.new(2018, 5, 16),
          [@reservation_plan_normal]
        ),
      ])
    end
  end
end
