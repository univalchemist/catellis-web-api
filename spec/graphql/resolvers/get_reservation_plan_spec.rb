require 'rails_helper'

RSpec.describe Resolvers::GetReservationPlan, type: :feature do
  def service_instance
    described_class.new
  end

  it "retrieves an existing reservation plan" do
    reservation_plan = create(:reservation_plan)
    user = create(:user, :restaurant_employee, restaurant: reservation_plan.restaurant)

    args = {
      id: reservation_plan.id,
    }
    ctx = {
      current_user: user
    }

    result = service_instance.call({}, args, ctx)

    expect(result).to eq reservation_plan
  end
end
