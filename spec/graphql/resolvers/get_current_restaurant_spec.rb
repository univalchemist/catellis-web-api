require 'rails_helper'

RSpec.describe Resolvers::GetCurrentRestaurant, type: :feature do
  def service_instance
    described_class.new
  end

  it "retrieves restaurant for employee" do
    restaurant = create(:restaurant)
    user = create(:user, :restaurant_employee, restaurant: restaurant)

    args = {
    }
    ctx = {
      current_user: user
    }

    result = service_instance.call({}, args, ctx)

    expect(result).to eq restaurant
  end
end
