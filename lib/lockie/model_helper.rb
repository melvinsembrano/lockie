module Lockie
  module ModelHelper
    def auth_object
      @auth_object ||= Lockie.config.model_name.classify
    end
  end
end
