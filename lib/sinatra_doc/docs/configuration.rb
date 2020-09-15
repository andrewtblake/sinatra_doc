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
      unless klass.connection.data_source_exists?(klass.table_name)
        warning = <<~WARNING
          ==> #{"SinatraDoc Warning:".colorize(:yellow)} #{"MISSING TABLE".colorize(:light_yellow)}
          ==> #{"SinatraDoc Warning:".colorize(:yellow)} Table `#{klass.table_name.colorize(:light_blue)}` is missing. There may be migrations that need running.
          ==> #{"SinatraDoc Warning:".colorize(:yellow)} Some attributes for model `#{klass.model_name.to_s.colorize(:light_blue)}` (ref `#{klass.doc_ref.to_s.colorize(:light_blue)}`) may not be documented.
        WARNING
        warn warning
      end
    end

    def response_template(name, code: nil, &block)
      response_templates
      response = Endpoint::Response.new(code)
      response.instance_eval(&block) if block_given?
      @response_templates[name.to_sym] = response
    end

    def prop_template(name, &block)
      prop_templates
      template = Endpoint::PropTemplate.new(name)
      template.instance_eval(&block) if block_given?
      @prop_templates << template
    end

    def register_tag(name, description: nil)
      tags
      @tags << { name: name, description: description }
    end

    def register_tags(tags_array)
      raise ArgumentError, "Tags must be an array" unless tags_array.is_a?(Array)
      tags_array.each{|tag| register_tag(tag) }
    end
  end
end
