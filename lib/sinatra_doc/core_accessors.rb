module SinatraDoc
  module CoreAccessors
    attr_accessor :last_defined_endpoint, :host, :title, :description, :version
    
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

    def model_classes
      @model_classes ||= []
    end

    def models
      model_classes.map{|klass| ModelProxy.new(klass) }
    end

    def response_templates
      @response_templates ||= {}
    end

    def tags
      @tags ||= []
    end
  end
end
