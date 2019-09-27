# frozen_string_literal: true

require "pry"

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require "twilito"

require "minitest/autorun"
require "minitest/spec"

require "webmock/minitest"

def stub_send_request(status: 201, response_body: {})
  uri = %r{api.twilio.com/#{Twilito::Configuration::TWILIO_VERSION}}
  response_body = response_body.to_json unless response_body.is_a?(String)
  stub_request(:post, uri).to_return(status: status, body: response_body)
end
