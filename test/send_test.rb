# frozen_string_literal: true

require "test_helper"

describe Twilito do
  before do
    Twilito.configure do |config|
      config.to = '+16145555555'
      config.from = '+16143333333'
      config.body = 'This is the body'
      config.account_sid = 'ACSID'
      config.auth_token = 'TOKEN'
    end
  end

  describe '.send_sms' do
    describe 'with a successful response from Twilio' do
      before do
        # NOTE: See test_helper.rb
        stub_send_request(response_body: { sid: 'some_sid' })
      end

      it 'returns a successful Twilito::Result' do
        result = Twilito.send_sms

        # TODO: unit tests for Result?
        assert_instance_of Twilito::Result, result
        assert_equal 'some_sid', result.sid
        assert_equal true, result.success?
        assert_equal [], result.errors
      end

      it 'POSTs to Twilio API with correct body' do
        Twilito.send_sms

        assert_requested(
          :post, 'https://api.twilio.com/2010-04-01/Accounts/ACSID/Messages.json',
          body: {
            To: '+16145555555',
            From: '+16143333333',
            Body: 'This is the body'
          },
          headers: {
            'User-Agent' => "Ruby Twilito/#{Twilito::VERSION}"
          }
        )
      end

      describe 'with options passed' do
        it 'POSTs to Twilio API with correct body, overriding configuration' do
          Twilito.send_sms(body: 'A different body', to: '+17405555555')

          assert_requested(
            :post, 'https://api.twilio.com/2010-04-01/Accounts/ACSID/Messages.json',
            body: {
              To: '+17405555555',
              From: '+16143333333',
              Body: 'A different body'
            }
          )
        end
      end

      describe 'with media_url passed' do
        it 'POSTs to Twilio API with correct body, overriding configuration' do
          Twilito.send_sms(media_url: 'https://demo.twilio.com/owl.png')

          assert_requested(
            :post, 'https://api.twilio.com/2010-04-01/Accounts/ACSID/Messages.json',
            body: {
              To: '+16145555555',
              From: '+16143333333',
              Body: 'This is the body',
              MediaUrl: 'https://demo.twilio.com/owl.png'
            }
          )
        end
      end

      describe 'with other arbitrary optional arguments passed' do
        it 'POSTs to Twilio API with optional arguments CamelCased' do
          Twilito.send_sms(status_callback: 'https://abc1234.free.beeceptor.com', foo_bar: 'baz')

          assert_requested(
            :post, 'https://api.twilio.com/2010-04-01/Accounts/ACSID/Messages.json',
            body: {
              To: '+16145555555',
              From: '+16143333333',
              Body: 'This is the body',
              StatusCallback: 'https://abc1234.free.beeceptor.com',
              FooBar: 'baz'
            }
          )
        end
      end
    end

    describe 'with an unsuccessful response from Twilio' do
      before do
        stub_send_request(status: 500, response_body: 'oh no')
        @result = Twilito.send_sms
      end

      it 'returns an unsuccessful Twilito::Result' do
        assert_instance_of Twilito::Result, @result
        assert_nil @result.sid
        assert_equal false, @result.success?
        assert_equal ['Error from Twilio API'], @result.errors
        assert_equal 'oh no', @result.response.read_body
      end
    end
  end

  describe '.send_sms!' do
    describe 'with an unsuccessful response from Twilio' do
      before do
        stub_send_request(status: 500, response_body: 'oh no')
      end

      it 'raises a Twilito::SendError' do
        error = assert_raises Twilito::SendError do
          Twilito.send_sms!
        end

        assert_equal 'Error from Twilio API', error.message
        assert_equal 'oh no', error.response.read_body
      end
    end
  end
end
