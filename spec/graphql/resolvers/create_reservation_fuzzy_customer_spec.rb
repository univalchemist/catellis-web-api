require 'rails_helper'

RSpec.describe Resolvers::CreateReservationFuzzyCustomer, type: :feature do
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
    customer = create(:customer)
    user = create(:user, :restaurant_employee, restaurant: customer.restaurant)

    args = {
      name: customer.name,
      phone_number: customer.phone_number,
      scheduled_start_at: (Time.zone.now + 2.hours).iso8601,
      party_size: 2,
      reservation_status: 'not_confirmed'
    }
    ctx = {
      current_user: user
    }

    result = service_instance.call({}, args, ctx)

    expect(result.status).to eq :reservation_created
    expect(result.reservation).to be_a(Reservation)
    expect(result.reservation).to be_persisted
  end

  it "does not create a new reservation for a partial match" do
    customer = create(:customer, name: 'Erik Rasmussen')
    user = create(:user, :restaurant_employee, restaurant: customer.restaurant)

    args = {
      name: 'Rasmussen',
      phone_number: customer.phone_number,
      scheduled_start_at: (Time.zone.now + 2.hours).iso8601,
      party_size: 2,
      reservation_status: 'not_confirmed'
    }
    ctx = {
      current_user: user
    }

    result = service_instance.call({}, args, ctx)


    expect(result.status).to eq :no_exact_match
    expect(result.reservation).to be_nil
    expect(result.suggested_customers).to include(customer)
  end

  it "returns no suggested customers when there are no matches" do
    restaurant = create(:restaurant)
    customer1 = create(:customer, name: 'Customer 1', restaurant: restaurant)
    customer2 = create(:customer, name: 'Customer 2', restaurant: restaurant)
    user = create(:user, :restaurant_employee, restaurant: restaurant)

    args = {
      name: 'Foo Bar',
      phone_number: '8445551234',
      scheduled_start_at: (Time.zone.now + 2.hours).iso8601,
      party_size: 2,
      reservation_status: 'not_confirmed'
    }
    ctx = {
      current_user: user
    }

    result = service_instance.call({}, args, ctx)

    expect(result.status).to eq :no_exact_match
    expect(result.reservation).to be_nil
    expect(result.suggested_customers).to be_empty
  end

  describe "returns selection of suggested customers when there are partial matches" do
    it "matches on customer name" do
      shared_customer_name = 'Customer'
      shared_customer_number = '8445551234'

      restaurant = create(:restaurant)
      customer1 = create(:customer, name: "#{shared_customer_name} 1", phone_number: shared_customer_number, restaurant: restaurant)
      customer2 = create(:customer, name: "#{shared_customer_name} 2", phone_number: shared_customer_number, restaurant: restaurant)
      user = create(:user, :restaurant_employee, restaurant: restaurant)

      args = {
        name: shared_customer_name,
        phone_number: shared_customer_number,
        scheduled_start_at: (Time.zone.now + 2.hours).iso8601,
        party_size: 2,
        reservation_status: 'not_confirmed'
      }
      ctx = {
        current_user: user
      }

      result = service_instance.call({}, args, ctx)

      expect(result.status).to eq :no_exact_match
      expect(result.reservation).to be_nil
      expect(result.suggested_customers).to include(customer1, customer2)
    end

    it "matches on customer name" do
      shared_customer_name = 'Customer'
      shared_customer_number = '8445551234'

      restaurant = create(:restaurant)
      customer1 = create(:customer, name: shared_customer_name, phone_number: shared_customer_number, restaurant: restaurant)
      user = create(:user, :restaurant_employee, restaurant: restaurant)

      args = {
        name: "Ms #{shared_customer_name}",
        phone_number: shared_customer_number,
        scheduled_start_at: (Time.zone.now + 2.hours).iso8601,
        party_size: 2,
        reservation_status: 'not_confirmed'
      }
      ctx = {
        current_user: user
      }

      result = service_instance.call({}, args, ctx)

      expect(result.status).to eq :no_exact_match
      expect(result.reservation).to be_nil
      expect(result.suggested_customers).to include(customer1)
    end
  end
end
