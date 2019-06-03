require 'test_helper'
require 'auth_test_helper'

class Lockie::Strategies::EmailPasswordJsonContentTypeTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  include AuthTestHelper

  setup do
    Lockie.configure do |c|
      c.model_name = "User"
    end
  end

  teardown do 
    reset_lockie!
    Warden.test_reset!
  end

  test "content should authenticate with email" do
    user = users(:one)
    post "/json", params: {
      email: user.email,
      password: 'Password123'
    }.to_json,
    headers: { "CONTENT_TYPE" => "application/json" }

    assert_equal "200", response.code
  end

  test "content should not authenticate invalid password" do
    user = users(:one)
    post "/json", params: {
      email: user.email,
      password: 'Password123121'
    }.to_json,
    headers: { "CONTENT_TYPE" => "application/json" }

    body = JSON.parse(response.body)
    assert_equal "401", response.code
    assert_equal "Invalid username or password", body["message"]
  end

end
