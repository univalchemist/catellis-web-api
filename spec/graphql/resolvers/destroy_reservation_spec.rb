require 'rails_helper'

RSpec.describe Resolvers::DestroyReservation, type: :feature do
  def service_instance
    described_class.new
  end

  it "destroys an existing reservation" do
    reservation = create(:reservation)
    user = create(:user, :restaurant_employee, restaurant: reservation.restaurant)

    args = {
      id: reservation.id
    }
    ctx = {
      current_user: user
    }

    result = service_instance.call({}, args, ctx)

    expect(result).to be_deleted
  end
end
