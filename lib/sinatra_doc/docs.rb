require_relative "docs/core_accessors"
require_relative "docs/configuration"

module SinatraDoc
  class << self
    include CoreAccessors
    include Configuration

    def adapt(adapter)
      adapter.core
    end
  end
end

require_relative "docs/sinatra"
require_relative "docs/endpoint"
require_relative "docs/endpoint_prop_types"
require_relative "docs/endpoint_prop"
require_relative "docs/endpoint_params"
require_relative "docs/endpoint_response"

require_relative "docs/model"

require_relative "adapter"
