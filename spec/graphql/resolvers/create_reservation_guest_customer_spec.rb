require 'rails_helper'

RSpec.describe Resolvers::CreateReservationGuestCustomer, type: :feature do
  def service_instance
    allow_any_instance_of(Notifications::CreateReservationNotification)
      .to(
        receive(:perform)
          .with(reservation: kind_of(Reservation))
          .and_return(nil)
      )

    described_class.new
  end

  it "creates a new reservation for a perfect match" do
    original_customer = create(:customer)
    user = create(:user, :restaurant_employee, restaurant: original_customer.restaurant)

    expected_scheduled_start_at = Time.zone.now + 2.hours

    args = {
      restaurant_id: original_customer.restaurant.id,
      name: original_customer.name,
      phone_number: original_customer.phone_number,
      email: nil,
      scheduled_start_at: expected_scheduled_start_at.iso8601,
      party_size: 2,
      party_notes: 'Food!',
    }

    result = service_instance.call({}, args, {})

    reservation = result.reservation
    expect(reservation).to be_a(Reservation)
    expect(reservation).to be_persisted
    expect(reservation.scheduled_start_at).to be_within(1.minutes).of(expected_scheduled_start_at)
    expect(reservation.party_size).to eq args[:party_size]
    expect(reservation.party_notes).to eq args[:party_notes]

    expect(result.customer).to eq original_customer
  end

  it "creates a new customer and reservation for a partial match" do
    original_customer = create(:customer, name: 'Erik Rasmussen')
    user = create(:user, :restaurant_employee, restaurant: original_customer.restaurant)

    args = {
      restaurant_id: original_customer.restaurant.id,
      name: 'Jana Rasmussen',
      phone_number: original_customer.phone_number,
      email: 'oh@hello',
      scheduled_start_at: (Time.zone.now + 2.hours).iso8601,
      party_size: 2,
    }

    result = service_instance.call({}, args, {})

    expect(result.reservation).to be_a(Reservation)
    expect(result.reservation).to be_persisted

    customer = result.customer
    expect(customer).not_to eq original_customer
    expect(customer).to be_a(Customer)
    expect(customer).to be_persisted
    expect(customer.name).to eq args[:name]
    expect(customer.phone_number).to eq args[:phone_number]
    expect(customer.email).to eq args[:email]
  end
end
