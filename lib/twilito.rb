# frozen_string_literal: true

require "twilito/version"
require "twilito/configuration"
require "twilito/result"

module Twilito
  class ArgumentError < StandardError; end
  class SendError < StandardError; end

  class << self
    def send_sms(**args)
      send_sms!(args)
      # TODO: return struct
    rescue SendError => e
      Result.new(success?: false, errors: [e.message])
    end

    def send_sms!(**args)
      _args = merge_configuration!(args)

      raise SendError, 'Not implemented'
    end

    private

    def merge_configuration!(**args)
      configuration.to_h.merge(args).tap do |merged|
        missing_keys = merged.map do |k, v|
          v.nil? ? k : nil
        end.compact

        if missing_keys.any?
          raise ArgumentError, "Missing argument(s): #{missing_keys.join(', ')}"
        end
      end
    end
  end
end
