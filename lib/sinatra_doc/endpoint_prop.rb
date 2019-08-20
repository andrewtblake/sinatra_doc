module SinatraDoc
  class Endpoint
    module PropMethods
      def prop(name, type, description = nil, **options, &block)
        prop = Prop.new(name, type, description, options)
        if block_given?
          raise ArgumentError, "Block given but not being used" unless prop.sub_props_allowed
          prop.instance_eval(&block)
        end
        push_prop(prop)
      end

      def model(ref, only: nil, **options)
        model = SinatraDoc.models.find{|x| x.ref == ref.to_sym }
        model.attributes.each do |prop_name, meta|
          next if only.is_a?(Array) && !only.include?(prop_name)
          push_prop(Prop.new(prop_name, meta[:type], meta[:description], options))
        end
      end

      def push_prop(prop)
        @props.delete_if{|x| x.name == prop.name }
        @props << prop
      end
    end

    class Prop
      include PropMethods

      attr_reader :name, :type, :description

      def initialize(name, type, description, **options)
        @name = name
        @type = type
        @description = description
        @required = options[:required] || false
        @of = options[:of]
        @in = options[:in]
        @props = []
        validate
      end

      def sub_props_allowed
        return false unless @type == :object || (@type == :array && @of == :object)
        true
      end

      def validate
        validation_type_valid
        validation_of_set_when_type_array
      end

      private

      def validation_type_valid
        raise ArgumentError, "Invalid prop type" unless PropTypes.values.include?(@type)
      end

      def validation_of_set_when_type_array
        raise ArgumentError, "Param `of` must be defined when `type` is array" if @type == :array && @of.nil?
      end
    end
  end
end
