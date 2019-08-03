module SinatraDoc
  class Endpoint
    class Response
      attr_reader :code

      def initialize(code)
        @code = code
        @props = []
      end

      def prop(name, type, description)
        prop = Prop.new(name, type, description)
        @props << prop
      end
    end
  end
end
