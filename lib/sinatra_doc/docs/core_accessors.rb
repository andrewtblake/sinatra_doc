module SinatraDoc
  module CoreAccessors
    attr_accessor :last_defined_endpoint, :host, :schemes, :title, :description, :version

    def all_endpoints
      endpoints = Sinatra::Application.routes.map do |method, method_endpoints|
        method_endpoints.map do |path|
          {
            method: method.to_sym,
            path: path[0].to_s,
            params: path_params(path[0].to_s)
          }
        end
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

    def path_params(path)
      path.scan(/:[\w]+/).map{|x| x[1..-1] }
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

    def prop_templates
      @prop_templates ||= []
    end

    def response_templates
      @response_templates ||= {}
    end

    def tags
      @tags ||= []
    end
  end
end
