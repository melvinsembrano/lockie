require 'test_helper'
require 'auth_test_helper'

class Lockie::ConfigurationTest < ActionDispatch::IntegrationTest
  include Warden::Test::Helpers
  include AuthTestHelper

  setup do

  end

  teardown do 
    reset_lockie!
    Warden.test_reset!
  end

  test "should allow custom session serializer" do
    Lockie.configure do |c|
      c.model_name = "User"
      c.serializer_to_session = proc {|u| u.id }
      c.serializer_from_session = proc {|id| User.find(id) }
    end
    user = users(:one)
    login_as user

    get "/hello"
    assert_equal "200", response.code
  end

end
