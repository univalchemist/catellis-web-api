require 'rails_helper'

RSpec.describe Resolvers::GetFloorPlanTable, type: :feature do
  def service_instance
    described_class.new
  end

  it "retrieves a floor plan table" do
    restaurant = create(:restaurant)
    user = create(:user, :restaurant_employee, restaurant: restaurant)
    floor_plan = create(
      :floor_plan,
      restaurant: restaurant,
      floor_plan_tables: [
        build(
          :floor_plan_table,
          x: 10,
          y: 10
        ),
      ]
    )

    expected_table = floor_plan.floor_plan_tables.first

    args = {
      id: expected_table.id,
    }
    ctx = {
      current_user: user
    }

    result = service_instance.call({}, args, ctx)

    expect(result).to eq expected_table
  end
end
