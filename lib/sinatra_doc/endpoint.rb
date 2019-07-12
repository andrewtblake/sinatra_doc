module SinatraDoc
  class Endpoint
    attr_reader :method, :path, :url

    def initialize(method, path)
      @method, @path = method, path
      @description = nil
      SinatraDoc.add_endpoint(self)
    end

    def description(value = nil)
      @description = value if value
      @description
    end
  end
end
