# frozen_string_literal: true

require "test_helper"

describe Twilito::Result do
  describe ".success" do
    it "creates a successful result" do
      response = Object.new
      def response.read_body
        '{"sid":"SM123456"}'
      end
      
      result = Twilito::Result.success(response: response, sid: "SM123456")
      
      assert result.success?
      assert_equal "SM123456", result.sid
      assert_equal [], result.errors
      assert_equal response, result.response
    end
  end

  describe ".failure" do
    it "creates a failed result" do
      response = Object.new
      def response.read_body
        '{"message":"Invalid number"}'
      end
      
      result = Twilito::Result.failure(response: response, errors: ["Invalid number"])
      
      refute result.success?
      assert_nil result.sid
      assert_equal ["Invalid number"], result.errors
      assert_equal response, result.response
    end
  end

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

    it "handles JSON parser errors" do
      response = Object.new
      def response.read_body
        'invalid json'
      end
      
      result = Twilito::Result.success(response: response, sid: "SM123456")
      
      assert_raises(JSON::ParserError) do
        result.data
      end
    end
  end
end