# frozen_string_literal: true

require "twilito/version"
require "twilito/configuration"
require "twilito/result"
require "twilito/api"
require "twilito/send_error"

module Twilito
  class ArgumentError < StandardError; end

  class << self
    include API

    def send_sms(**args)
      send_sms!(**args)
    rescue SendError => e
      Result.failure(errors: [e.message], response: e.response)
    end

    def send_sms!(**args)
      args = merge_configuration(args)
      response = send_response(args)

      unless response.is_a? Net::HTTPSuccess
        raise SendError.new('Error from Twilio API', response)
      end

      Result.success(response: response, sid: JSON.parse(response.body)['sid'])
    rescue JSON::ParserError => e
      raise SendError.new("Unable to parse response from Twilio API. Error: #{e.message}", response)
    end

    private

    def merge_configuration(args)
      configuration.to_h.merge(args).tap do |merged|
        missing_keys = merged.select { |_k, v| v.nil? }.keys

        # Only one of :from or :messaging_service_sid must be set
        missing_keys = [] if (missing_keys == [:from]) || (missing_keys == [:messaging_service_sid])
        missing_keys = missing_keys.map do |key|
          key == :from ? "from (or messaging_service_sid)" : key
        end
        missing_keys.delete(:messaging_service_sid)

        raise ArgumentError, "Missing argument(s): #{missing_keys.join(', ')}" if missing_keys.any?
      end
    end
  end
end
