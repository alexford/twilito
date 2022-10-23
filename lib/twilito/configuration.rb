# frozen_string_literal: true

module Twilito
  def self.configure
    yield(configuration)
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset_configuration!
    @configuration = Configuration.new
  end

  class Configuration
    attr_accessor :account_sid, :auth_token, :from, :to, :body,
                  :twilio_host, :twilio_version, :messaging_service_sid

    TWILIO_HOST = 'api.twilio.com'
    TWILIO_VERSION = '2010-04-01'

    def to_h
      {
        to: to,
        from: from,
        messaging_service_sid: messaging_service_sid,
        body: body,
        account_sid: account_sid,
        auth_token: auth_token
      }
    end
  end
end
