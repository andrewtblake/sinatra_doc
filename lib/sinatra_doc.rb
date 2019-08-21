require "active_support"
require "active_support/inflector"
require "json"

module SinatraDoc
  class << self
    attr_accessor :last_defined_endpoint

    def all_endpoints
      endpoints = Sinatra::Application.routes.map do |method, method_endpoints|
        method_endpoints.map{|path| { method: method.to_sym, path: path[0].to_s } }
      end
      endpoints.flatten!
      endpoints.sort_by!{|x| [ x[:path], x[:method]] }
      default_filter(endpoints)
    end

    def default_filter(endpoints)
      endpoints.select do |endpoint|
        [ :GET, :POST, :PUT, :PATCH, :DELETE ].include?(endpoint[:method]) && \
          endpoint[:path] != "*"
      end
    end

    def endpoints
      @endpoints ||= []
    end

    def add_endpoint(endpoint)
      endpoints
      @endpoints << endpoint
      self.last_defined_endpoint = endpoint
    end

    def model_classes
      @model_classes ||= []
    end

    def add_model(klass)
      model_classes
      @model_classes << klass
    end

    def models
      model_classes.map{|klass| ModelProxy.new(klass) }
    end

    def response_templates
      @response_templates ||= {}
    end

    def response_template(name, code: nil, &block)
      response_templates
      response = Endpoint::Response.new(code)
      response.instance_eval(&block) if block_given?
      @response_templates[name.to_sym] = response
    end

    def tags
      endpoints.collect(&:tags).flatten.sort
    end
  end
end

require_relative "sinatra_doc/version"
require_relative "sinatra_doc/sinatra"
require_relative "sinatra_doc/endpoint"
require_relative "sinatra_doc/endpoint_prop_types"
require_relative "sinatra_doc/endpoint_prop"
require_relative "sinatra_doc/endpoint_params"
require_relative "sinatra_doc/endpoint_response"

require_relative "sinatra_doc/model"
require_relative "sinatra_doc/adapter"

require_relative "sinatra_doc/adapters/swagger"
