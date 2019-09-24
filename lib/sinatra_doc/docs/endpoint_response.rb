module SinatraDoc
  class Endpoint
    class Response
      include PropMethods

      attr_accessor :code, :description

      def initialize(code = nil, description = nil)
        @code = code
        @description = description
        @props = []
      end

      def adapt(adapter)
        adapter.response(self)
      end
    end
  end
end
