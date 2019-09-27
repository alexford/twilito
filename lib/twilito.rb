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
      response = send_sms!(args)
      Result.success(
        response: response,
        sid: JSON.parse(response.read_body)['sid']
      )
    rescue SendError => e
      Result.failure(errors: [e.message], response: e.response)
    rescue JSON::ParserError
      Result.failure(errors: ['Unable to parse response'], response: response)
    end

    def send_sms!(**args)
      args = merge_configuration(args)

      send_response(args).tap do |response|
        unless response.is_a? Net::HTTPSuccess
          raise SendError.new('Error from Twilio API', response)
        end
      end
    end

    private

    def merge_configuration(**args)
      configuration.to_h.merge(args).tap do |merged|
        missing_keys = merged.select { |_k, v| v.nil? }.keys

        if missing_keys.any?
          raise ArgumentError, "Missing argument(s): #{missing_keys.join(', ')}"
        end
      end
    end
  end
end
