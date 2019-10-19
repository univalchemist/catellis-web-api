require 'rails_helper'

RSpec.describe Resolvers::DestroyFloorPlan, type: :feature do
  def service_instance
    described_class.new
  end

  it "destroys an existing floor plan" do
    floor_plan = create(:floor_plan)
    user = create(:user, :restaurant_employee, restaurant: floor_plan.restaurant)

    args = {
      id: floor_plan.id
    }
    ctx = {
      current_user: user
    }

    result = service_instance.call({}, args, ctx)

    expect(result).to be_deleted
  end
end
