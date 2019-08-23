require "active_support"
require "active_support/inflector"
require "json"

require_relative "sinatra_doc/core_accessors"
require_relative "sinatra_doc/configuration"

module SinatraDoc
  class << self
    include CoreAccessors
    include Configuration

    def adapt(adapter)
      adapter.core
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
