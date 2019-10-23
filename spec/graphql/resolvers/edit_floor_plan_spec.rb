require 'rails_helper'

RSpec.describe Resolvers::EditFloorPlan, type: :feature do
  def service_instance
    described_class.new
  end

  it "edits an existing floor plan" do
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
        )
      ]
    )

    expected_floor_plan_name = "Patio"

    args = {
      input: {
        id: floor_plan.id,
        name: expected_floor_plan_name,
        floor_plan_tables_attributes: [
          {
            id: floor_plan.floor_plan_tables.first.id,
            x: 20,
            y: 20,
            table_rotation: 90
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
    first_table = result.floor_plan_tables.first
    expect(first_table.x).to eq 20
    expect(first_table.y).to eq 20
    expect(first_table.table_rotation).to eq 90
  end

  it "adds new table to a floor plan" do
    restaurant = create(:restaurant)
    user = create(:user, :restaurant_employee, restaurant: restaurant)
    floor_plan = create(
      :floor_plan,
      restaurant: restaurant,
    )

    args = {
      input: {
        id: floor_plan.id,
        name: floor_plan.name,
        floor_plan_tables_attributes: [
          {
            x: 20,
            y: 20,
            table_number: 'A1',
            table_size: 4,
            table_shape: 'rectangle',
            table_type: 'indoor',
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
    expect(result.name).to eq floor_plan.name
    expect(result.floor_plan_tables.count).to eq 1
    # first_table = result.floor_plan_tables.first
    # expect(first_table.x).to eq 20
    # expect(first_table.y).to eq 20
  end

  it "removes existing table from a floor plan" do
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
        )
      ]
    )

    args = {
      input: {
        id: floor_plan.id,
        name: floor_plan.name,
        floor_plan_tables_attributes: [
          {
            id: floor_plan.floor_plan_tables.first.id,
            _destroy: true
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
    expect(result.name).to eq floor_plan.name
    expect(result.floor_plan_tables.count).to eq 0
  end
end
