# frozen_string_literal: true

module Twilito
  class Result
    attr_reader :success, :errors, :sid, :response

    def initialize(success:, errors: [], sid: nil, response: nil)
      @success = success
      @errors = errors
      @sid = sid
      @response = response
    end

    def self.success(response:, sid:)
      new(success: true, response: response, sid: sid)
    end

    def self.failure(response:, errors:)
      new(success: false, response: response, errors: errors)
    end

    def data
      JSON.parse(response_body || '{}')
    end

    def success?
      success || false
    end

    private

    def response_body
      return nil unless response&.respond_to?(:read_body)

      response.read_body
    end
  end
end
