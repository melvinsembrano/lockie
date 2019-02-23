module Lockie
  module Strategies
    class EmailPassword < ::Warden::Strategies::Base
      include Lockie::ModelHelper
      include Lockie::LogHelper

      def request
        @request ||= ActionDispatch::Request.new(env)
      end

      def valid?
        request.params['email'].present? && request.params['password'].present?
      end

      def authenticate!
        auth = auth_object.find_by_email(request.params['email'])

        if auth && auth.authenticate(request.params['password'])
          success!(auth)
        else
          set_message('Invalid username or password')
        end
      end

    end
  end
end
Warden::Strategies.add(:email_password, Lockie::Strategies::EmailPassword)
