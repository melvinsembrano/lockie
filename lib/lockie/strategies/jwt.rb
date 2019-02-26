module Lockie
  module Strategies
    class Jwt < ::Warden::Strategies::Base
      include Lockie::ModelHelper
      include Lockie::LogHelper

      def auth
        @auth ||= ActionDispatch::Request.new(env)
      end

      def headers
        auth.headers
      end

      def valid?
        headers['Authorization'].present?
      end

      def token
        headers['Authorization'].split.last.strip
      end

      def authenticate!
        begin
          auth = auth_object.find_by_token(token)
          if auth
            success! auth
          else
            set_message "Invalid token"
            fail!
          end
        rescue # => err
          set_message "Invalid token"
          fail!
        end
      end

    end
  end
end

Warden::Strategies.add(:jwt, Lockie::Strategies::Jwt)

