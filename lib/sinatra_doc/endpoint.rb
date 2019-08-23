module SinatraDoc
  class Endpoint
    attr_accessor :method, :path
    attr_reader :responses

    def initialize
      @method, @path, @description = nil, nil, nil
      @tags, @responses = [], []
      SinatraDoc.add_endpoint(self)
    end

    def validate
      validation_body_params
    end

    def description(value = nil)
      @description = value if value
      @description
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

    def params(**options, &block)
      case options[:in]
      when :body
        body_params
        @body_params.instance_eval(&block) if block_given?
      else
        url_params
        @url_params.instance_eval(&block) if block_given?
      end
    end

    def body_params(auto_initialize: true)
      return @body_params unless auto_initialize
      @body_params ||= ParamCollection.new(:body)
    end

    def url_params
      @url_params ||= ParamCollection.new
    end

    def response(template = nil, code: nil, description: nil, &block)
      if template
        response = SinatraDoc.response_templates[template]
        response.code = code unless code.nil?
        response.description = description unless description.nil?
        raise ArgumentError, "Response template not found" if response.nil?
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
  end
end
