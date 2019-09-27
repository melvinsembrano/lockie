require 'test_helper'
class Lockie::ControllerHelper::Test < ActiveSupport::TestCase
  include Warden::Test::Helpers

  class User
    include Lockie::ModelHelper

    def initialize(record)
      @record = record
    end

    def id
      @record.dig(:id)
    end

    def self.find(id)
      {id: "1", name: "melvin"}
    end
  end

  setup do
    Lockie.configure do |c|
      c.jwt_secret = "jwt-secret"
    end
  end

  test "#create_token" do
    user = User.new({})
    assert user.respond_to?(:create_token)
  end

  test "#self.find_by_token" do
    assert User.respond_to?(:find_by_token)
  end

  test "#self.find_by_token will return record" do
    record = {id: "1", name: "melvin"}

    token = User.new(record).create_token
    assert_equal record, User.find_by_token(token)
  end

  test "#self.extract_auth_id" do
    payload = {"aud"=>"lockie-app", "sub"=>"1", "sub_type"=>"User"}
    assert_equal "1", User.extract_auth_id(payload)
  end

  test "#self.decode_token" do
    token = User.create_token(payload: {
      sub_type: "System",
      sub: "101",
    }, secret: Lockie.config.jwt_secret)

    payloads = User.decode_token token
    assert_equal "101", payloads.first.dig("sub")
    assert_equal "System", payloads.first.dig("sub_type")
  end

end
