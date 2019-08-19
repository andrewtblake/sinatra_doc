# typed: true
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

    def response(code, &block)
      response = Response.new(code)
      response.instance_eval(&block) if block_given?
      @responses << response
    end
  end
end
