require 'rails'
require 'warden'
require_relative "lockie/rails"
require_relative "lockie/failure_app"
require_relative "lockie/log_helper"
require_relative "lockie/model_helper"
require_relative "lockie/controller_helper"
require_relative "lockie/strategies/email_password"
require_relative "lockie/strategies/jwt"
require_relative "lockie/strategies/failed"

module Lockie

  class Configuration
    attr_accessor :model_name
    attr_accessor :unauthenticated_path
    attr_accessor :default_strategies
    attr_accessor :jwt_secret
    attr_accessor :hash_algorithm
    attr_accessor :serialize_session
    attr_accessor :callback_url
    attr_accessor :scopes
    attr_accessor :serializer_to_session, :serializer_from_session
    attr_accessor :session_timeout
    attr_accessor :failure_app

    def initialize
      @model_name = "User"
      @unauthenticated_path = "/login"
      @default_strategies = [:email_password, :jwt]
      @hash_algorithm = "HS256"
      @serialize_session = true
      @callback_url = true
      @scopes = []
      @serializer_to_session = nil
      @serializer_from_session = nil
      @session_timeout = 3.hours
      @failure_app = Lockie::FailureApp
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
