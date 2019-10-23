require 'twilio_support'

class Notifications::WaitlistToSeatedReservationNotification
  def perform(reservation:)
    twilio_client = TwilioSupport.build_default_client

    # TODO: Probably should investigate externalizing this message so it's
    # easier to maintain.
    twilio_client.send_message(
      to: "+1#{reservation.customer.phone_number}",
      body: "Hey, #{reservation.customer.name}! We are now ready to seat your party. Please see the host to be seated."
    )
  end
end
