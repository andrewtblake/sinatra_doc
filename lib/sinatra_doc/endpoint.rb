module SinatraDoc
  class Endpoint
    attr_accessor :method, :path
    attr_reader :responses

    def initialize
      @method, @path, @description = nil, nil, nil
      @tags, @responses = [], []
      SinatraDoc.add_endpoint(self)
    end

    def description(value = nil)
      @description = value if value
      @description
    end

    def tags(value = nil)
      @tags = value if value
      @tags
    end

    def params(&block)
      @params ||= ParamCollection.new()
      return @params unless block_given?
      @params.instance_eval(&block)
    end

    def response(template = nil, code: nil, &block)
      if template
        response = SinatraDoc.response_templates[template]
        response.code = code unless code.nil?
        raise ArgumentError, "Response template not found" if response.nil?
      else
        response = Response.new(code)
      end
      raise ArgumentError, "All responses must have a code" if response.code.nil?
      response.instance_eval(&block) if block_given?
      @responses << response
    end
  end
end
