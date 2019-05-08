require 'lockie/model_helper'

module Lockie
  class Engine < ::Rails::Engine

    config.app_middleware.use Warden::Manager do |manager|
        manager.default_strategies Lockie.config.default_strategies
        manager.failure_app = Lockie::FailureApp

        if Lockie.config.serialize_session
          manager.serialize_into_session(&:email)
          manager.serialize_from_session do |email|
            Lockie.config.model_name.classify.constantize.find_by_email(email)
          end
        end

      end
  end
end

Warden::Manager.after_set_user do |record, warden, options|
end
