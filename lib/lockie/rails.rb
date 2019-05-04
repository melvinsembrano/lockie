require 'lockie/model_helper'

module Lockie
  class Engine < ::Rails::Engine

    config.app_middleware.use Warden::Manager do |manager|
        manager.default_strategies Lockie.config.default_strategies
        manager.failure_app = Lockie::FailureApp

        manager.serialize_into_session(&:id)
				manager.serialize_from_session do |id|
          Lockie.config.model_name.classify.constantize.find(id)
				end

      end
  end
end

Warden::Manager.after_set_user do |record, warden, options|
end
