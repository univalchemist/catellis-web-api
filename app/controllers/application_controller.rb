class ApplicationController < ActionController::API

  def sms
    body = params["Body"].downcase
    from = params["From"].remove("+1")

    customer = Customer.where(phone_number: from).last
    reservation = customer.reservations.last

    twiml = Twilio::TwiML::MessagingResponse.new do |resp|
      if body == 'cancel reservation'
        if reservation.canceled?
          resp.message body: 'Your reservation has already been canceled. See you next time!'
        else
          if reservation.cancel
            resp.message body: 'Your reservation has been canceled. See you next time!'
          else
            resp.message body: 'Your reservation has NOT been canceled. We encountered a problem. Please give us a call.'
          end
        end
      else
        resp.message body: 'Response CANCEL to cancel your reservation. For all other needs, call us!'
      end
    end

    twiml.to_s
  end

end
