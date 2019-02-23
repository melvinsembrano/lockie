require 'lockie/model_helper'

module Lockie
  class Engine < ::Rails::Engine
    include Lockie::ModelHelper

    config.app_middleware.use Warden::Manager do |manager|
        manager.default_strategies Lockie.config.default_strategies
        manager.failure_app = Lockie::FailureApp

        manager.serialize_into_session(&:id)
				manager.serialize_from_session do |id|
					auth_object.find(id)
				end

      end
  end
end
