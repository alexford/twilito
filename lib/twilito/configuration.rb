# frozen_string_literal: true

module Twilito
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :account_sid, :auth_token, :from, :to, :body
  end
end