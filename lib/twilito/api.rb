# frozen_string_literal: true

module Twilito
  module API
    def send_response(args)
      uri = messages_uri(args[:account_sid])

      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        req = Net::HTTP::Post.new(uri)
        req.initialize_http_header('User-Agent' => user_agent)
        req.basic_auth(args[:account_sid], args[:auth_token])
        req.set_form_data(twilio_form_data(args))

        http.request(req)
      end
    end

    def messages_uri(account_sid)
      components = [
        Configuration::TWILIO_VERSION,
        'Accounts',
        account_sid,
        'Messages.json'
      ]

      URI::HTTPS.build(
        host: Configuration::TWILIO_HOST,
        path: '/' + components.join('/')
      )
    end

    private

    # NOTE: Converts snake_cased hash of arguments to CamelCase to match Twilio
    # API expectations. Also, removes auth_token and account_sid as those are
    # included separately in .send_response as basic auth instead of POST body
    def twilio_form_data(args)
      args
        .merge(auth_token: nil, account_sid: nil).compact
        .reduce({}) { |result, (k, v)| result.merge(k.to_s.split('_').collect(&:capitalize).join => v) }
    end

    def user_agent
      "Ruby Twilito/#{Twilito::VERSION}"
    end
  end
end
