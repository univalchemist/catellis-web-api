# FIXME: I have no spec.

class Reservations::CreateReservationService < BaseService
  Result = build_result_struct(:reservation)

  def initialize(notification_service: nil)
    @notification_service = notification_service || ::Notifications::CreateReservationNotification.new
  end

  def perform(restaurant:, customer:, reservation_data:)
    reservation = nil
    ActiveRecord::Base.transaction do
      reservation = Reservation.new(
        restaurant: restaurant,
        customer: customer,
        **reservation_data
      )

      if (reservation.scheduled_end_at.nil?)
        reservation.scheduled_end_at = reservation.scheduled_start_at + reservation.turn_time.hours
      end

      reservation.save!

      begin
        notification_service.perform(
          reservation: reservation
        )
      rescue Twilio::REST::RestError => error
        # TODO: Respond with mixed success/error message.
      end
    end

    Result.new(
      success: true,
      reservation: reservation
    )
  end

protected

  attr_reader :notification_service
end
