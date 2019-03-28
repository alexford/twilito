# frozen_string_literal: true

module Twilito
  module API
    def send_response(args)
      uri = messages_uri(args)

      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        req = Net::HTTP::Post.new(uri)
        req.basic_auth(args[:account_sid], args[:auth_token])
        req.set_form_data(twilio_params(args))

        http.request(req)
      end
    end

    private

    def twilio_params(args)
      {
        'To' => args[:to],
        'From' => args[:from],
        'Body' => args[:body]
      }
    end

    def messages_uri(args)
      components = [
        Configuration::TWILIO_VERSION,
        'Accounts',
        args[:account_sid],
        'Messages.json'
      ]

      URI::HTTPS.build(
        host: Configuration::TWILIO_HOST,
        path: '/' + components.join('/')
      )
    end
  end
end
