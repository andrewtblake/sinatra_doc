module SinatraDoc
  class Endpoint
    attr_accessor :method, :path

    def initialize
      @method, @path, @description = nil
      @tags = []
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
  end
end
