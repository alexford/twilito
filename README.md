# Twilito

[![Build Status](https://travis-ci.org/alexford/twilito.svg?branch=master)](https://travis-ci.org/alexford/twilito)

A tiny, zero dependency helper for sending text messages with Twilio

## Why

Twilio's full on Ruby library does a lot, and has a large memory footprint—too large for just sending an SMS. It's also more difficult to mock and verify than I'd like for a simple task like sending an individual SMS.

Using Twilio's REST API directly is fine, but can be cumbersome.

Twilito is just enough of a wrapper to abstract away the REST API without loading the rest of the Twilio ecosystem.

## Usage

#### Install the gem

```
gem 'twilito'
```

#### Simplest case

```ruby
# All options are required (but can be defaulted, see below)
result = Twilito.send_sms(
  to: '+15555555555',
  from: '+15554444444',
  content: 'This is my content'
  account_sid: '...', # Twilio Credentials
  auth_token: '...'
)

# Returns Twilito::Result struct

result.success? # => boolean
result.errors # => [] or error messages
result.sid #=> Twilio SID for Message (SM[...])
result.response # => Raw API Response
```

#### Use send! to raise on error instead

```ruby
Twilito.send_sms!(
  to: '+15555555555',
  from: '+12333',
  body: 'This is my content',
  account_sid: '...',
  auth_token: '...'
) # => raises Twilito::RestError with message
```

#### Every argument can be defaulted

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

#### Really, everything

```ruby
# In an initializer or something like that:

Twilito.configure do |config|
  # Store your secrets elsewhere
  config.account_sid = ENV['TWILIO_ACCOUNT_SID']
  config.auth_token = ENV['TWILIO_AUTH_TOKEN']

  config.from = '+16145555555'
  config.to = '+15555555555'
  config.body = 'A new user signed up'
end
```

```ruby
# Later, in your code:

Twilito.send_sms!
```

## Testing your code

_TODO: Add examples of mocking and/or test helpers for asserting your code sends an SMS_

## Contributing

_TODO_
