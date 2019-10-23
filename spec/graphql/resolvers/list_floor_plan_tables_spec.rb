require 'rails_helper'

RSpec.describe Resolvers::ListFloorPlanTables, type: :feature do
  def service_instance
    described_class.new
  end

  it "retrieves floor plan tables for restaurant" do
    restaurant = create(:restaurant)
    user = create(:user, :restaurant_employee, restaurant: restaurant)
    floor_plan_1 = create(
      :floor_plan,
      restaurant: restaurant,
      floor_plan_tables: [
        build(
          :floor_plan_table,
          x: 10,
          y: 10
        ),
        build(
          :floor_plan_table,
          x: 10,
          y: 10
        )
      ]
    )
    floor_plan_2 = create(
      :floor_plan,
      restaurant: restaurant,
      floor_plan_tables: [
        build(
          :floor_plan_table,
          x: 10,
          y: 10
        )
      ]
    )
    expected_floor_plan_tables = [
      *floor_plan_1.floor_plan_tables,
      *floor_plan_2.floor_plan_tables
    ]

    args = {
    }
    ctx = {
      current_user: user
    }

    result = service_instance.call({}, args, ctx)

    expect(result).to include(*expected_floor_plan_tables.to_a)
  end
end
