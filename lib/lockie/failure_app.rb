require 'action_controller/metal'
module Lockie
  class FailureApp < ActionController::Metal
    include ActionController::Redirecting

    delegate :flash, to: :request

    def self.call(*args)
      req = ActionDispatch::Request.new(*args)
      action(req.env['warden.options'][:action]).call(*args)
    end

    def unauthenticated
      if request.xhr?
        api_response(:text)
      elsif request.format.to_sym == :json || request.content_type.to_s.split("/").last == 'json'
        api_response(:json)
      else
        html_response
      end
    end

    def api_response(format = :text)
      self.status = 401
      self.content_type = request.format.to_s
      if format.eql?(:text)
        self.response_body  = message
      else
        self.response_body  = { message: message }.to_json
      end
    end

    def html_response
      flash[type] = message if message
      self.status = 302
      callback_url = request.base_url + request.original_fullpath
      uri = URI(Lockie.config.unauthenticated_path)
      uri.query = (uri.query.to_s.split("&") << "callback_url=#{ callback_url }").join("&")
      redirect_to uri.to_s
    end

    def message
      @message ||= request.env['warden.message'] || "Unauthorized"
    end

    def warden_options
      request.env['warden.options']
    end

    def type
      @type ||= warden_options[:type] || :error
    end

    def warden
      env['warden']
    end

  end
end
