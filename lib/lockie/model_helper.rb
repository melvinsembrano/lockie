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
        payloads = decode_token token
        find_auth payloads.first
      end

      def find_auth(payload)
        auth_id = extract_auth_id payload
        find auth_id
      end

      def extract_auth_id(payload)
        payload.fetch('sub') { nil }
      end

      def decode_token(token)
        JWT.decode(token, Lockie.config.jwt_secret, true, { algorithm: Lockie.config.hash_algorithm })
      end

      def create_token(payload: {}, secret: , hash_algorithm: 'HS256')
        payload = {
          aud: 'lockie-app',
        }.merge(payload)

        JWT.encode(payload, secret, hash_algorithm)
      end

    end
  end
end
