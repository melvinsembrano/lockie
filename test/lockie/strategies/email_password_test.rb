require 'test_helper'
require 'auth_test_helper'

class Lockie::Strategies::DefaultTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  include AuthTestHelper

  teardown { Warden.test_reset! }

  test "should authenticate with email" do
    user = users(:one)
    post "/web", params: {
      email: user.email,
      password: 'Password123'
    }
    assert_equal "200", response.code
  end

  test "should not authenticate invalid password" do
    user = users(:one)
    post "/web", params: {
      email: user.email,
      password: 'Password123121'
    }
    assert_equal "302", response.code
  end


end
