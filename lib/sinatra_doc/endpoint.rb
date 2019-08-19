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

    def response(code_or_template, &block)
      case code_or_template
      when Integer
        response = Response.new(code_or_template)
        response.instance_eval(&block) if block_given?
      when Symbol
        response = SinatraDoc.response_templates[code_or_template]
        raise ArgumentError, "Response template not found" if response.nil?
      else
        raise ArgumentError, "Must pass either a Symbol or Integer"
      end
      @responses << response
    end
  end
end
