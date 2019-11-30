# frozen_string_literal: true

module Twilito
  Result = Struct.new(:success, :errors, :sid, :response) do
    def initialize(success:, errors: [], sid: nil, response: nil)
      super(success, errors, sid, response)
    end

    def self.success(**args)
      new(success: true, **args)
    end

    def self.failure(**args)
      new(success: false, **args)
    end

    def data
      JSON.parse(response_body || '{}')
    end

    def success?
      to_h[:success] || false
    end

    private

    def response_body
      return nil unless to_h[:response]&.respond_to?(:read_body)

      to_h[:response].read_body
    end
  end
end
