require 'rails'
require 'warden'
require_relative "lockie/rails"
require_relative "lockie/log_helper"
require_relative "lockie/model_helper"
require_relative "lockie/strategies/email_password"
require_relative "lockie/strategies/jwt"
require_relative "lockie/strategies/failed"

module Lockie
  autoload :FailureApp, 'lockie/failure_app'

  class Configuration
    attr_accessor :model_name
    attr_accessor :unauthenticated_path
    attr_accessor :default_strategies

    def initialize
      @model_name = "User"
      @unauthenticated_path = "/login"
      @default_strategies = [:email_passwrd, :jwt]
    end
  end

  class << self
    def configure
      yield config
    end

    def config
      @config ||= Configuration.new
    end
  end
end
