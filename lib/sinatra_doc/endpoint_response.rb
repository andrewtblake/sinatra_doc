module SinatraDoc
  class Endpoint
    class Response
      include PropMethods

      attr_accessor :code

      def initialize(code = nil)
        @code = code
        @props = []
      end
    end
  end
end
