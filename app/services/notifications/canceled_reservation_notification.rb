require 'twilio_support'

class Notifications::CanceledReservationNotification
  def perform(reservation:)
    twilio_client = TwilioSupport.build_default_client

    local_scheduled_start_at = reservation.local_scheduled_start_at
    reservation_date = local_scheduled_start_at.strftime("%b %e")
    reservation_time = local_scheduled_start_at.strftime("%l:%M %P").strip

    # TODO: Probably should investigate externalizing this message so it's
    # easier to maintain.
    twilio_client.send_message(
      to: "+1#{reservation.customer.phone_number}",
      body: "Hey, #{reservation.customer.name}! Your reservation for #{reservation.restaurant.name} at #{reservation_time} on #{reservation_date} for #{reservation.party_size} guests has been canceled. If you have any questions, please give us a call."
    )
  end
end
