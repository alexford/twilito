# frozen_string_literal: true

require "test_helper"

describe Twilito::Result do
  describe "#data" do
    it "parses JSON response body" do
      response = Object.new
      def response.read_body
        '{"sid":"SM123456","status":"queued"}'
      end

      result = Twilito::Result.success(response: response, sid: "SM123456")

      assert_equal({"sid" => "SM123456", "status" => "queued"}, result.data)
    end

    it "returns empty hash for nil response" do
      result = Twilito::Result.new(success: true, sid: "SM123456")

      assert_equal({}, result.data)
    end
  end
end
