# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands
- Install dependencies: `bundle install`
- Run all tests: `bundle exec rake test`
- Run single test file: `bundle exec ruby -Ilib:test test/file_name_test.rb`
- Run specific test: `bundle exec ruby -Ilib:test test/file_name_test.rb:LINE_NUMBER`
- Run linter: `bundle exec rubocop`

## Style Guidelines
- Use frozen_string_literal pragma comment
- 2-space indentation
- CamelCase for classes, snake_case for methods and variables
- Custom error classes inherit from StandardError
- Use Result pattern for API responses
- Document public methods using YARD
- Tests use Minitest with WebMock for HTTP mocking
- Configuration via module accessor pattern
