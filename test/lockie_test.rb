require 'test_helper'

class Lockie::Test < ActiveSupport::TestCase
  include Warden::Test::Helpers

  teardown do
    reset_lockie!
    Warden.test_reset!
  end

  test "truth" do
    assert_kind_of Module, Lockie
  end

end
