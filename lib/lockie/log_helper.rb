module Lockie
  module LogHelper

    def set_message(message)
      env['warden.message'] = message
    end
  end
end
