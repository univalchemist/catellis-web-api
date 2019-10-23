require 'rails_helper'

RSpec.describe Resolvers::CreateFloorPlan, type: :feature do
  def service_instance
    described_class.new
  end

  it "creates a new floor plan" do
    restaurant = create(:restaurant)
    user = create(:user, :restaurant_employee, restaurant: restaurant)

    expected_floor_plan_name = "Patio"

    args = {
      input: {
        name: expected_floor_plan_name,
        floor_plan_tables_attributes: [
          {
            x: 10,
            y: 10,
            table_number: "1",
            table_size: 4,
            table_type: 'indoor',
            table_shape: 'rectangle',
            min_covers: 2,
            max_covers: 4
          }
        ]
      }
    }
    ctx = {
      current_user: user
    }

    result = service_instance.call({}, args, ctx)

    expect(result).to be_a(FloorPlan)
    expect(result).to be_persisted
    expect(result.name).to eq expected_floor_plan_name
    expect(result.floor_plan_tables.count).to eq 1
  end
end
