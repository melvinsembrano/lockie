module Lockie
  module Strategies
    class Jwt < ::Warden::Strategies::Base
      include Lockie::ModelHelper
      include Lockie::LogHelper

      def headers
        @headers ||= ActionDispatch::Http::Headers.new(env)
      end

      def valid?
        headers['Authorization'].present? && headers['Authorization'].split.first.strip == 'Bearer'
      end

      def token
        headers['Authorization'].split.last.strip
      end

      def authenticate!
        begin
          auth = auth_object.find_by_token(token)
          if auth
            success! auth
          end
        rescue => err
          set_message "Invalid token"
          throw :warden, message: err.message
        end
      end

    end
  end
end

Warden::Strategies.add(:jwt, Lockie::Strategies::Jwt)

