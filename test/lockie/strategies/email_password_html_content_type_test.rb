require 'test_helper'
require 'auth_test_helper'

class Lockie::Strategies::EmailPasswordHtmlContentTypeTest < ActionDispatch::IntegrationTest
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
    post "/web", params: {
      email: user.email,
      password: 'Password123'
    }
    assert_equal "200", response.code
  end

  test "content should not authenticate invalid password" do
    user = users(:one)
    post "/web", params: {
      email: user.email,
      password: 'Password123121'
    }
    assert_equal "302", response.code
  end

end
