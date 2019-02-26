class User < ApplicationRecord
  has_secure_password
  include Lockie::ModelHelper

end
