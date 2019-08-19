# typed: true
module SinatraDoc
  class Endpoint
    class Response
      include PropMethods

      attr_reader :code

      def initialize(code)
        @code = code
        @props = []
      end
    end
  end
end
