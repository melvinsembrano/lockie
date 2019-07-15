module Lockie
  module ControllerHelper
    extend ActiveSupport::Concern

    included do

      if respond_to?(:helper_method)
        helper_method "current_#{ Lockie.config.model_name.underscore.gsub(/\//, '_') }".to_sym
        helper_method :logged_in?
        helper_method :authenticated?
      end

      def warden
        return request.env['warden'] if defined?(request)
        env['warden']
      end

      define_method "current_#{ Lockie.config.model_name.underscore.gsub(/\//, '_') }".to_sym do |*args|
        warden.user(*args)
      end

      def authenticate!(scope = warden.config.default_scope)
        warden.authenticate!({ scope: scope }.compact)
      end

      def authenticate(scope = warden.config.default_scope)
        warden.authenticate({ scope: scope }.compact)
      end

      def authenticated?(*args)
        warden.authenticated?(*args)
      end
      alias logged_in? authenticated?

      def logout(*args)
        authenticated?(args)
        warden.logout
      end

    end
  end
end
