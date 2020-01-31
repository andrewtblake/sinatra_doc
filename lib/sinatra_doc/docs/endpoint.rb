module SinatraDoc
  class Endpoint
    attr_accessor :method
    attr_reader :path, :responses

    def initialize
      @method, @path, @available_path_params, @description, @consumes = nil, nil, nil, nil, :json
      @tags, @responses = [], []
      SinatraDoc.add_endpoint(self)
    end

    def path=(value)
      raise ArgumentError, "Path must be string" unless value.is_a?(String)
      @path = value
      @available_path_params = SinatraDoc.path_params(@path)
    end

    def available_path_params
      @available_path_params ||= []
    end

    def validate
      validation_only_defined_path_props
      validation_all_path_props_defined
      validation_body_params
    end

    def description(value = nil)
      @description = value if value
      @description
    end

    def tag(value)
      tags << value
    end

    def tags(value = nil)
      if value
        raise ArgumentError, "Tags must be an array" unless value.is_a?(Array)
        registered_tag_names = SinatraDoc.tags.collect{|x| x[:name] }
        raise ArgumentError, "All tags must be registered" unless value.all?{|x| registered_tag_names.include?(x) }
        @tags = value
      end
      @tags
    end

    CONSUMES_MAP = {
      json: "application/json",
      form_data: "multipart/form-data"
    }.freeze

    def consumes(value = nil)
      if value
        raise ArgumentError, "Endpoints must only consume one of: #{CONSUMES_MAP.keys.join(", ")}" unless CONSUMES_MAP.keys.include?(value)
        @consumes = value
      end
      @consumes
    end

    def consumes_value
      CONSUMES_MAP[@consumes]
    end

    def params(**options, &block)
      case options[:in]
      when :path
        path_params
        @path_params.instance_eval(&block) if block_given?
      when :body
        body_params
        @body_params.instance_eval(&block) if block_given?
      else
        url_params
        @url_params.instance_eval(&block) if block_given?
      end
    end

    def path_params
      @path_params ||= ParamCollection.new(:path)
    end

    def url_params
      @url_params ||= ParamCollection.new
    end

    def body_params(auto_initialize: true)
      return @body_params unless auto_initialize
      @body_params ||= ParamCollection.new(:body)
    end

    def response(template = nil, code: nil, description: nil, &block)
      if template
        response = SinatraDoc.response_templates[template]
        raise ArgumentError, "Response template not found" if response.nil?
        response = response.full_clone
        response.code = code unless code.nil?
        response.description = description unless description.nil?
      else
        response = Response.new(code, description)
      end
      raise ArgumentError, "All responses must have a code" if response.code.nil?
      response.instance_eval(&block) if block_given?
      @responses << response
    end

    def adapt(adapter)
      adapter.endpoint(self)
    end

    private

    def validation_body_params
      return unless [ :GET, :DELETE ].include?(@method.upcase.to_sym) && !body_params(auto_initialize: false).nil?
      raise ArgumentError, "Body params not supported for given http method"
    end

    def validation_only_defined_path_props
      return if path_params.props.all?{|param| available_path_params.include?(param.name.to_s) }
      raise ArgumentError, "All path params must be defined in the route block"
    end

    def validation_all_path_props_defined
      defined_path_props = path_params.props.collect{|x| x.name.to_s }
      return if available_path_params.all?{|param| defined_path_props.include?(param) }
      raise ArgumentError, "All defined path props must be documented"
    end
  end
end
