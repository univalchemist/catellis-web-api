require 'twilio_support'

class Notifications::CreateReservationNotification
  def perform(reservation:)
    twilio_client = TwilioSupport.build_default_client

    local_scheduled_start_at = reservation.local_scheduled_start_at
    reservation_date = local_scheduled_start_at.strftime("%b %e")
    reservation_time = local_scheduled_start_at.strftime("%l:%M %P").strip

    body = nil
    case reservation.reservation_status.to_sym
    when :waitlist
      body = "Hey, #{reservation.customer.name}! We have you on the waitlist for #{reservation.restaurant.name} at #{reservation_time} on #{reservation_date} for #{reservation.party_size} guests. See you soon. If you have any questions, please give us a call."
    else
      body = "Hey, #{reservation.customer.name}! We got your reservation for #{reservation.restaurant.name} at #{reservation_time} on #{reservation_date} for #{reservation.party_size} guests confirmed. See you soon. If you have any questions, please give us a call."
    end

    # TODO: Probably should investigate externalizing this message so it's
    # easier to maintain.
    twilio_client.send_message(
      to: "+1#{reservation.customer.phone_number}",
      body: body
    )
  end
end
