# frozen_string_literal: true

module Twilito
  Result = Struct.new(:success?, :errors, :sid, :response, keyword_init: true) do
    def self.success(**args)
      new(success?: true, **args)
    end

    def self.failure(**args)
      new(success?: false, **args)
    end

    def errors
      to_h[:errors] || []
    end

    def data
      JSON.parse(response_body || '{}')
    end

    private

    def response_body
      return nil unless to_h[:response]&.respond_to?(:read_body)

      to_h[:response].read_body
    end
  end
end
