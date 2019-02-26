require 'test_helper'
require 'auth_test_helper'

class Lockie::Strategies::JwtTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  include AuthTestHelper

  setup do
    Lockie.configure do |c|
      c.jwt_secret = "jwt-secret"
      c.model_name = "User"
    end
  end

  teardown { Warden.test_reset! }

  test "should authenticate" do
    user = users(:one)
    post "/json", headers: {'HTTP_AUTHORIZATION' => "Bearer #{ user.create_token }", 'CONTENT_TYPE' => 'application/json'}
    assert_equal "200", response.code
  end

  test "should not authenticate with expired token" do
    user = users(:one)
    post "/json", headers: {'HTTP_AUTHORIZATION' => "Bearer #{ user.create_token(exp: 1.hour.ago.to_i) }", 'CONTENT_TYPE' => 'application/json'}
    assert_equal "401", response.code
  end


end
