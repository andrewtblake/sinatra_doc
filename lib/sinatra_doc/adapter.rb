module SinatraDoc
  class Adapter
    class << self
      def basic_prop(_prop)
        warn "Adapter hasn't definded how to convert a basic prop"
        nil
      end
    end
  end
end
