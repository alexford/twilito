# frozen_string_literal: true

module Twilito
  class SendError < StandardError
    attr_reader :response

    def initialize(message, response)
      @response = response
      super(message)
    end
  end
end
