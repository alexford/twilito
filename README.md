# Twilito

A tiny, zero dependency helper for sending text messages with Twilio. _Just enough_ of a wrapper to abstract away Twilio's REST API for sending messages, without _anything_ else.

[![Gem Version](https://badge.fury.io/rb/twilito.svg)](https://badge.fury.io/rb/twilito) [![Actions Status](https://github.com/alexford/twilito/workflows/CI/badge.svg)](https://github.com/alexford/twilito/actions)

## Why

Twilio's [full Ruby library](https://github.com/twilio/twilio-ruby) does a _lot_, and has a large memory footprint to go with it—too large for just sending a message. It's also more difficult to mock and verify in tests than I'd like.

Using [Twilio's REST API](https://www.twilio.com/docs/usage/api) directly is fine, but can be cumbersome.

You should consider using Twilito if the only thing you need to do is send text messages and you don't want to worry about making HTTP requests to Twilio yourself.

If you use more of Twilio, consider [twilio-ruby](https://github.com/twilio/twilio-ruby) or interact with the REST API in another way.

## Usage

Twilito is designed for currently maintained Ruby versions. (3.2 and up as of 12/2025). Unit tests [run in CI](https://github.com/alexford/twilito/actions) on 3.2, 3.3, and 3.4

#### Install the gem

```
gem 'twilito'
```

#### Simplest case

```ruby
# All of these arguments are required, but can be configured as defaults (see below)
result = Twilito.send_sms(
  to: '+15555555555',
  from: '+15554444444', # or 'messaging_service_sid'
  body: 'This is my content',
  account_sid: '...', # Twilio Credentials
  auth_token: '...'
)


# Returns instance of Twilito::Result

result.success? # => boolean
result.errors # => [] or error messages
result.sid #=> Twilio SID for Message (SM[...])
result.response # => Raw response (instance of Net::HTTPResponse)
result.data # => Hash of response data (parsed from JSON)
```

#### Use send_sms! to raise on error instead

```ruby
begin
  Twilito.send_sms!(
    to: '+15555555555',
    from: '+12333',
    body: 'This is my content',
    account_sid: '...',
    auth_token: '...'
  )
rescue Twilito::SendError => e
  e.message # => 'Error from Twilio API'
  e.response # => Raw response (instance of Net::HTTPResponse)
end
```

### Configuring Defaults For Required Arguments

The five required arguments (`to`, `from` (or `messaging_service_sid`), `body`, `account_sid`, and `auth_token`) can be configured as defaults with `Twilito.configure`.

```ruby
# In an initializer or something like that:

Twilito.configure do |config|
  # Store your secrets elsewhere
  config.account_sid = ENV['TWILIO_ACCOUNT_SID']
  config.auth_token = ENV['TWILIO_AUTH_TOKEN']

  config.from = '+16145555555'
end
```

```ruby
# Later, in your code:

Twilito.send_sms!(to: '+15555555555', body: 'Foo')
```

### Using Other, Optional (Arbitrary) Arguments

There are a number of optional parameters defined by Twilio for sending a message (see [the API documentation](https://www.twilio.com/docs/sms/api/message-resource#create-a-message-resource)). Any of these can be sent with Twilito using the "Ruby-style" snake cased equivalent of the parameter.

```ruby
# Twilito sends arbitrary arguments to Twilio's API after CamelCasing keys to match Twilio's style.
# NOTE: This example assumes auth_token, account_sid, and from have already been configured.

result = Twilito.send_sms(
  to: '+15555555555',
  body: 'This is my content',
  media_url: 'https://example.com/image.png', # MediaUrl
  status_callback: 'https://your.app.io/sms/callback', # StatusCallback
  smart_encoded: true # SmartEncoded
)
```

## Testing your code

_TODO: Add examples of mocking and/or test helpers for asserting your code sends an SMS_

## Contributing

### Contribute Feedback, Ideas, and Bug Reports

- Create or comment on an issue

### Contribute Code

- Find an open issue or create one
- Fork this repo and open a PR
- Write unit tests for your change

### Contribute Docs

- Open a PR to make the README better, or help with contribution guidelines, etc.
- There is currently an open issue for adding RDoc/YARD documentation

### Contribute Beer

Did Twilito save you some RAM?

<a href="https://www.buymeacoffee.com/alexford" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/lato-white.png" alt="Buy Me A Beer" height="51" width="217" style="height: 51px !important;width: 217px !important;" ></a>
