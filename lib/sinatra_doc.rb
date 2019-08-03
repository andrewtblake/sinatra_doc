require "json"
require "sorbet-runtime"

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
  end
end

require_relative "sinatra_doc/version"
require_relative "sinatra_doc/block"
require_relative "sinatra_doc/endpoint"
