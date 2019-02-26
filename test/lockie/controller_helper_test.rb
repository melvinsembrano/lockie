require 'test_helper'
class Lockie::ControllerHelper::Test < ActiveSupport::TestCase

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
end
