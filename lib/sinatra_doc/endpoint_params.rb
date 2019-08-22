module SinatraDoc
  class Endpoint
    class ParamCollection
      include PropMethods

      def initialize
        @props = []
      end

      def adapt(adapter)
        adapter.params(self)
      end
    end
  end
end
