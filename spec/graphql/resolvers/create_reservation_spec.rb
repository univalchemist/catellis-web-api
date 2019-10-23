require 'rails_helper'

RSpec.describe Resolvers::CreateReservation, type: :feature do
  def service_instance(create_reservation_service)
    described_class.new(create_reservation_service: create_reservation_service)
  end

  it "creates a new reservation" do
    customer = create(:customer)
    user = create(:user, :restaurant_employee, restaurant: customer.restaurant)

    args = {
      customer_id: customer.id,
      scheduled_start_at: (Time.zone.now + 2.hours).iso8601,
      party_size: 2,
      reservation_status: 'not_confirmed'
    }
    ctx = {
      current_user: user
    }

    # notification_service = instance_double(Notifications::CreateReservationNotification)
    # expect(notification_service)
    #   .to(
    #     receive(:perform)
    #       .with(reservation: kind_of(Reservation))
    #       .and_return(nil)
    #   )
    #
    # result = service_instance(notification_service).call({}, args, ctx)


    mock_result = quick_instance_double(
      Reservations::CreateReservationService::Result,
      {
        success: true,
        reservation: {}
      }
    )

    create_service = instance_double(Reservations::CreateReservationService)
    expect(create_service)
      .to(
        receive(:perform)
          .with(
            restaurant: customer.restaurant,
            customer: customer,
            reservation_data: args.slice(:scheduled_start_at, :party_size, :reservation_status)
          )
          .and_return(mock_result)
      )

    result = service_instance(create_service).call({}, args, ctx)

    # expect(result).to be_success
    # expect(result).to be_a(Reservation)
  end

  # FIXME: this spec really belongs to new CreateReservationService
  xit "creates a new reservation even if the notification subsystem fails" do
    customer = create(:customer)
    user = create(:user, :restaurant_employee, restaurant: customer.restaurant)

    args = {
      customer_id: customer.id,
      scheduled_start_at: (Time.zone.now + 2.hours).iso8601,
      party_size: 2,
      reservation_status: 'not_confirmed'
    }
    ctx = {
      current_user: user
    }

    notification_service = instance_double(Notifications::CreateReservationNotification)
    expect(notification_service)
      .to(
        receive(:perform)
          .with(reservation: kind_of(Reservation))
          .and_raise(Twilio::REST::RestError.new('error', 'error', 400))
      )

    result = service_instance(notification_service).call({}, args, ctx)

    expect(result).to be_a(Reservation)
    expect(result).to be_persisted
  end
end
