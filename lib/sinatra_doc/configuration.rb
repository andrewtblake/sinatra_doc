module SinatraDoc
  module Configuration
    def configure(&block)
      self.class_eval(&block)
    end

    def add_endpoint(endpoint)
      endpoints
      @endpoints << endpoint
      self.last_defined_endpoint = endpoint
    end

    def add_model(klass)
      model_classes
      @model_classes << klass
    end

    def response_template(name, code: nil, &block)
      response_templates
      response = Endpoint::Response.new(code)
      response.instance_eval(&block) if block_given?
      @response_templates[name.to_sym] = response
    end
    
    def register_tag(name, description: nil)
      tags
      @tags << { name: name, description: description }
    end
  end
end
