require 'rails_helper'

RSpec.describe Resolvers::ReservationPlans::EditReservationPlan, type: :feature do
  def service_instance
    described_class.new
  end

  it "edits existing reservation plan" do
    restaurant = create(:restaurant)
    user = create(:user, :restaurant_employee, restaurant: restaurant)
    floor_plan_1 = create(:floor_plan, name: 'FP1', restaurant: restaurant)
    floor_plan_2 = create(:floor_plan, name: 'FP2', restaurant: restaurant)
    reservation_plan = create(
      :reservation_plan,
      restaurant: restaurant,
      repeat: :annually,
      effective_date_start_at: DateTime.new(2018, 4, 1).iso8601,
      effective_date_end_at: DateTime.new(2018, 9, 30).iso8601,
      floor_plans: [
        floor_plan_1
      ]
    )
    floor_plan_1_join = reservation_plan.reservation_plan_floor_plans.first

    expected_name = "Summer Lunch"
    expected_time_start = DateTime.new(2000, 1, 1, 10)
    expected_time_end = DateTime.new(2000, 1, 1, 14)

    args = {
      input: {
        id: reservation_plan.id,
        name: expected_name,
        effective_time_start_at: expected_time_start.iso8601,
        effective_time_end_at: expected_time_end.iso8601,
        cust_reservable_start_at: expected_time_start.iso8601,
        cust_reservable_end_at: expected_time_end.iso8601,
        repeat: 'annually',
        active_weekday_0: true,
        active_weekday_1: true,
        active_weekday_2: true,
        active_weekday_3: true,
        active_weekday_4: true,
        active_weekday_5: true,
        active_weekday_6: true,
        effective_date_start_at: DateTime.new(2018, 4, 1).iso8601,
        effective_date_end_at: DateTime.new(2018, 9, 30).iso8601,
        reservation_plan_floor_plans_attributes: [
          {
            floor_plan_id: floor_plan_2.id,
          },
          {
            id: floor_plan_1_join.id,
            _destroy: true
          }
        ]
      }
    }
    ctx = {
      current_user: user
    }

    result = service_instance.call({}, args, ctx)

    expect(result).to eq reservation_plan
    expect(result.name).to eq expected_name
    expect(result.effective_time_start_at).to eq expected_time_start
    expect(result.effective_time_end_at).to eq expected_time_end
    expect(result.cust_reservable_start_at).to eq expected_time_start
    expect(result.cust_reservable_end_at).to eq expected_time_end
    expect(result).to be_repeat_annually
    expect(result.active_weekday_0).to be true
    expect(result.active_weekday_1).to be true
    expect(result.active_weekday_2).to be true
    expect(result.active_weekday_3).to be true
    expect(result.active_weekday_4).to be true
    expect(result.active_weekday_5).to be true
    expect(result.active_weekday_6).to be true
    expect(result.effective_date_start_at).to eq DateTime.new(2000, 4, 1)
    expect(result.effective_date_end_at).to eq DateTime.new(2000, 9, 30)
    expect(result.floor_plans.first).to eq floor_plan_2
  end
end
