# frozen_string_literal: true

require "test_helper"

describe Twilito do
  def setup
    Twilito.configure do |config|
      config.to = '+16145555555'
      config.from = '+16143333333'
      config.body = 'This is the body'
      config.account_sid = 'ACSID'
      config.auth_token = 'TOKEN'
    end
  end

  describe '.send_sms' do
    it "returns a Twilito::Result" do
      assert_instance_of Twilito::Result, Twilito.send_sms
    end

    it "has errors because sending is not implemented" do
      result = Twilito.send_sms

      assert_equal false, result.success?
      assert_equal ["Not implemented"], result.errors
      assert_nil result.sid
      assert_nil result.response
    end
  end

  describe '.send_sms!' do
    it "raises an error because sending is not implemented" do
      error = assert_raises Twilito::SendError do
        Twilito.send_sms!
      end

      assert_equal "Not implemented", error.message
    end
  end
end
