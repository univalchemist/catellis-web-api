require 'rails_helper'

RSpec.describe Resolvers::GetMarketingRestaurant, type: :feature do
  def service_instance
    described_class.new
  end

  it "retrieves first restaurant" do
    restaurant = create(:restaurant)

    args = {
    }
    ctx = {
    }

    result = service_instance.call({}, args, ctx)

    expect(result).to eq restaurant
  end
end
