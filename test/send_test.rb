# frozen_string_literal: true

require "test_helper"

describe Twilito do
  it "requires all arguments" do
    assert_raises Twilito::ArgumentError do
      Twilito.send_sms
    end
  end
end
