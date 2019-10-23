require 'rails_helper'

RSpec.describe Resolvers::ListFloorPlans, type: :feature do
  def service_instance
    described_class.new
  end

  it "retrieves floor plans for restaurant" do
    restaurant = create(:restaurant)
    user = create(:user, :restaurant_employee, restaurant: restaurant)
    floor_plan = create(:floor_plan, restaurant: restaurant)

    args = {
    }
    ctx = {
      current_user: user
    }

    result = service_instance.call({}, args, ctx)

    expect(result).to include(floor_plan)
  end
end
