require 'lockie/model_helper'

module Lockie
  class Engine < ::Rails::Engine

    config.app_middleware.use Warden::Manager do |manager|
        manager.default_strategies Lockie.config.default_strategies
        manager.failure_app = Lockie::FailureApp

        if Lockie.config.serialize_session
          serializer_to_session = Lockie.config.serializer_to_session || proc { |u| [u.class.name, u.id] }
          manager.serialize_into_session(&serializer_to_session)
          serializer_from_session = Lockie.config.serializer_from_session || proc { |s| s.first.constantize.find(s.last) }
          manager.serialize_from_session(&serializer_from_session)
        end

        Lockie.config.scopes.each do |scope|
          manager.scope_defaults(*scope)
        end

      end
  end
end

Warden::Manager.after_authentication do |record, warden, options|
  session_key = "warden.uls-#{record.class.name.underscore}-#{record.id}"
  warden.request.session[session_key] = (Time.now + Lockie.config.session_timeout).to_s
end

Warden::Manager.after_set_user do |record, warden, options|
  session_key = "warden.uls-#{record.class.name.underscore}-#{record.id}"
  last_session_access = warden.request.session[session_key]

  if last_session_access && Time.parse(last_session_access) < Time.now
    # session expired
    warden.logout
  end

  warden.request.session[session_key] = Time.now + Lockie.config.session_timeout
end
