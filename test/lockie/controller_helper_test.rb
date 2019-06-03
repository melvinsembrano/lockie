require 'test_helper'
class Lockie::ControllerHelper::Test < ActiveSupport::TestCase
  include Warden::Test::Helpers

  teardown do
    reset_lockie!
    Warden.test_reset!
  end

  test "current authe helper should be #current_user" do
    Lockie.configure do |c|
      c.model_name = "User"
    end
    class UserAuthController
      include Lockie::ControllerHelper
    end
    controller = UserAuthController.new
    assert controller.respond_to?(:current_user)
  end

  test "current authe helper should be #current_account" do
    Lockie.configure do |c|
      c.model_name = "Account"
    end
    class AccountAuthController
      include Lockie::ControllerHelper
    end
    controller = AccountAuthController.new
    assert controller.respond_to?(:current_account)
  end

  # test "should serialize session properly with custom serializer" do
  #   Lockie.configure do |c|
  #     c.model_name = "User"
  #     c.serializer_to_session = proc { |u| u.id }
  #     c.serializer_from_session = proc { |id| User.find (id) }
  #   end

  #   class UserAuthController
  #     include Lockie::ControllerHelper
  #   end
  #   user = users(:one)
  #   login_as user
  #   controller = UserAuthController.new
  #   puts controller.current_user.inspect

  # end
end
