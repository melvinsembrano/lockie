require 'jwt'

module Lockie
  module ModelHelper
    extend ActiveSupport::Concern

    def auth_object
      @auth_object ||= Lockie.config.model_name.classify.constantize
    end

    included do

        def create_token(payload = {})
          payload = {
            aud: 'lockie-app',
            sub: id,
            sub_type: self.class.name,
          }.merge(payload)

          JWT.encode(payload, Lockie.config.jwt_secret, Lockie.config.hash_algorithm)
        end
    end

    class_methods do

      def find_by_token(token)
        payload = JWT.decode(token, Lockie.config.jwt_secret, true, { algorithm: Lockie.config.hash_algorithm })
        auth_id = payload.first.fetch('sub') { nil }
        find(auth_id)
      end

      def create_token(payload: {}, secret:)
        payload = {
          aud: 'lockie-app',
        }.merge(payload)

        JWT.encode(payload, secret, 'HS256')
      end

    end
  end
end
