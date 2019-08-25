module SinatraDoc
  class Adapter
    class << self
      def core
        warn "Adapter hasn't definded how to start conversion"
        nil
      end

      def endpoint(_endpoint)
        warn "Adapter hasn't definded how to convert an endpoint"
        nil
      end

      def path_params(_params)
        warn "Adapter hasn't definded how to convert path params"
        nil
      end

      def url_params(_params)
        warn "Adapter hasn't definded how to convert url params"
        nil
      end

      def body_params(_params)
        warn "Adapter hasn't definded how to convert body params"
        nil
      end

      def response(_response)
        warn "Adapter hasn't definded how to convert a response"
        nil
      end

      def basic_prop(_prop)
        warn "Adapter hasn't definded how to convert a basic prop"
        nil
      end

      def array_prop(_prop)
        warn "Adapter hasn't definded how to convert an array prop"
        nil
      end

      def object_prop(_prop)
        warn "Adapter hasn't definded how to convert an object prop"
        nil
      end
    end
  end
end
