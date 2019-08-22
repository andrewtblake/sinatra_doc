module SinatraDoc
  class Adapter
    class << self
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
