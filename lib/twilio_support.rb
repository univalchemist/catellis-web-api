module TwilioSupport
  def self.build_default_client
    MessageServiceClient.new(
      account_sid: Global.twilio.account_sid,
      auth_token: Global.twilio.auth_token,
      messaging_service_sid: Global.twilio.messaging_service_sid
    )
  end

  class MessageServiceClient
    attr_reader :client, :messaging_service_sid

    def initialize(account_sid:, auth_token:, messaging_service_sid:)
      @client = Twilio::REST::Client.new(
        account_sid,
        auth_token
      )

      @messaging_service_sid = messaging_service_sid
    end

    def send_message(to:, body:)
      @client.messages.create(
        messaging_service_sid: messaging_service_sid,
        to: to,
        body: body
      )
    end
  end
end
