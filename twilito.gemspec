# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "twilito/version"

Gem::Specification.new do |spec|
  spec.name          = "twilito"
  spec.licenses      = ['MIT']
  spec.version       = Twilito::VERSION
  spec.authors       = ["Alex Ford"]
  spec.email         = ["alexford@hey.com"]
  spec.required_ruby_version = '>= 3.0'

  spec.summary       = "A tiny, zero dependency, and easy to test helper for sending text messages with Twilio"
  spec.homepage      = "https://github.com/alexford/twilito"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "minitest", "~> 5.11"
  spec.add_development_dependency "pry", "~> 0.14"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "webmock", "~> 3.12"
  spec.add_development_dependency "yard", "~> 0.9"
end
