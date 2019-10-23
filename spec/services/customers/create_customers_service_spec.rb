require 'rails_helper'

RSpec.describe Customers::CreateCustomersService, type: :feature do
  def service_instance
    described_class.new
  end

  it "creates a customer for the current employee's restaurant" do
    restaurant = create(:restaurant)
    rest_employee = create(
      :user,
      :restaurant_employee,
      restaurant: restaurant
    )

    expected_name = 'New Customer'
    expected_phone_number = '8445551234'
    expected_email = 'foo@bar'

    results = service_instance.perform(
      args: {
        name: expected_name,
        phone_number: expected_phone_number,
        email: expected_email
      },
      ctx: {
        current_user: rest_employee
      }
    )

    expect(results.customer).to be_persisted
  end
end
