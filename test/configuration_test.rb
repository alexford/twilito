# frozen_string_literal: true

require "test_helper"

describe Twilito do
  def setup
    Twilito.reset_configuration!
  end

  it "requires all arguments for .send_sms" do
    error = assert_raises Twilito::ArgumentError do
      Twilito.send_sms
    end

    assert_match "to, from, body, account_sid, auth_token", error.message
  end

  it "does not require arguments for .send_sms once configured as defaults" do
    Twilito.configure do |config|
      config.body = 'foo'
    end

    error = assert_raises Twilito::ArgumentError do
      Twilito.send_sms
    end

    assert_match "to, from, account_sid, auth_token", error.message
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
end
