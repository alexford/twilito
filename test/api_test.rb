# frozen_string_literal: true

require "test_helper"

# Create a test class to expose API methods
class APITest
  include Twilito::API
end

describe Twilito::API do
  before do
    @api = APITest.new
    Twilito.reset_configuration!
    Twilito.configure do |config|
      config.account_sid = 'ACSID'
      config.auth_token = 'TOKEN'
    end
  end

  describe "#messages_uri" do
    it "builds correct Twilio API URI" do
      uri = @api.messages_uri('ACSID')
      
      assert_equal "https://api.twilio.com/2010-04-01/Accounts/ACSID/Messages.json", uri.to_s
    end
  end

  describe "#send_response" do
    it "makes HTTP request with correct parameters" do
      args = {
        to: "+16145555555",
        from: "+16143333333",
        body: "Test message",
        account_sid: "ACSID",
        auth_token: "TOKEN"
      }

      stub_request(:post, "https://api.twilio.com/2010-04-01/Accounts/ACSID/Messages.json")
        .with(
          body: {"To" => "+16145555555", "From" => "+16143333333", "Body" => "Test message"},
          headers: {'User-Agent' => "Ruby Twilito/#{Twilito::VERSION}"}
        )
        .to_return(status: 201, body: {sid: "SM123456"}.to_json)

      response = @api.send_response(args)
      
      assert_instance_of Net::HTTPCreated, response
      assert_equal({sid: "SM123456"}.to_json, response.body)
    end
  end
end