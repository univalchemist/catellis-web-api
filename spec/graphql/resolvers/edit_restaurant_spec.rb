require 'rails_helper'

RSpec.describe Resolvers::EditRestaurant, type: :feature do
  def service_instance
    described_class.new
  end

  it "successfully updates restaurant" do
    restaurant = create(:restaurant)
    user = create(:user, :restaurant_owner, restaurant: restaurant)

    expected_name = 'New Name'
    expected_timezone_name = 'America/Los_Angeles'
    expected_rest_open_at = Time.zone.parse('2000-01-01 09:00:00')
    expected_rest_close_at = Time.zone.parse('2000-01-01 23:00:00')

    args = {
      id: restaurant.id,
      name: expected_name,
      timezone_name: expected_timezone_name,
      rest_open_at: '09:00',
      rest_close_at: '23:00'
    }
    ctx = {
      current_user: user
    }

    result = service_instance.call({}, args, ctx)

    expect(result.name).to eq expected_name
    expect(result.timezone_name).to eq expected_timezone_name
    expect(result.rest_open_at).to eq expected_rest_open_at
    expect(result.rest_close_at).to eq expected_rest_close_at
  end
end
