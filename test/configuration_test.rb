# frozen_string_literal: true

require "test_helper"

describe Twilito do
  before do
    Twilito.reset_configuration!
    stub_request(:post, /api.twilio.com/)
  end

  it "requires all arguments for .send_sms" do
    error = assert_raises Twilito::ArgumentError do
      Twilito.send_sms
    end

    assert_match "to, from (or messaging_service_sid), body, account_sid, auth_token", error.message
  end

  it "does not include 'missing' arguments that are previously configured in the error message" do
    Twilito.configure do |config|
      config.body = 'foo'
    end

    error = assert_raises Twilito::ArgumentError do
      Twilito.send_sms
    end

    assert_match "to, from (or messaging_service_sid), account_sid, auth_token", error.message
  end

  it "does not require any arguments for .send_sms if they're all configured" do
    Twilito.configure do |config|
      config.to = '+16145555555'
      config.from = '+16143333333'
      config.body = 'foo'
      config.account_sid = 'ACSID'
      config.auth_token = 'TOKEN'
    end

    Twilito.send_sms
  end

  describe "either from OR messaging_service_sid is required" do
    before do
      Twilito.configure do |config|
        config.to = '+16145555555'
        config.body = 'foo'
        config.account_sid = 'ACSID'
        config.auth_token = 'TOKEN'
      end
    end

    it "does not require `from` for .send_sms if `messaging_service_sid` is provided" do
      Twilito.configure do |config|
        config.messaging_service_sid = 'MSSID'
      end

      Twilito.send_sms
    end

    it "does not require `messaging_service_sid` for .send_sms if `from` is provided" do
      Twilito.configure do |config|
        config.from = '+16144444444'
      end

      Twilito.send_sms
    end
  end
end
