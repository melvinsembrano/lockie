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
        api_response
      elsif request.format.to_sym == :xml || request.content_type.to_s.split("/").last == 'xml'
        api_response(:xml)
      elsif request.format.to_sym == :json || request.content_type.to_s.split("/").last == 'json'
        api_response(:json)
      else
        html_response
      end
    end

    def api_response(format = :text)
      self.status = 401
      self.content_type = request.format.to_s
      if format.eql?(:json)
        self.response_body  = { message: message }.to_json
      elsif format.eql?(:xml)
        self.response_body  = { message: message }.to_xml
      else
        self.response_body  = message
      end
    end

    def html_response
      flash[type] = message if message
      self.status = 302
      redirect_to Lockie.config.unauthenticated_path
    end

    def message
      @message ||= request.env['warden.message']
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
