module SinatraDoc
  class Endpoint
    attr_accessor :method, :path

    def initialize
      @method, @path, @description = nil
      SinatraDoc.add_endpoint(self)
    end

    def description(value = nil)
      @description = value if value
      @description
    end
  end
end
