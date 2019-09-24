module SinatraDoc
  class Endpoint
    class ParamCollection
      include PropMethods

      def self.allowed_in_values
        [ :path, :url, :body ]
      end

      attr_reader :in

      def initialize(location = nil)
        @in = location || :url
        @props = []
        validation_in_values
      end

      def adapt(adapter)
        case @in
        when :path
          adapter.path_params(self)
        when :url
          adapter.url_params(self)
        when :body
          adapter.body_params(self)
        end
      end

      def validation_in_values
        return if self.class.allowed_in_values.include?(@in)
        raise ArgumentError, "Param `in` must be one of the following values: #{self.class.allowed_in_values.join(", ")}"
      end
    end
  end
end
