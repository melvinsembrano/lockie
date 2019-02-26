module Lockie
  module Strategies
    class Failed < ::Warden::Strategies::Base
      include Lockie::LogHelper

      def valid?
        true
      end

      def authenticate!
        set_message 'Unauthorised'
        fail!
      end
    end
  end
end
Warden::Strategies.add(:failed, Lockie::Strategies::Failed)
