module SinatraDoc
  class Endpoint
    module PropMethods
      attr_reader :props

      def prop(name, type, description = nil, **options, &block)
        prop = Prop.new(name, type, description, options)
        if block_given?
          raise ArgumentError, "Block given but not being used" unless prop.sub_props_allowed
          prop.instance_eval(&block)
        end
        push_prop(prop)
      end

      def model(ref, only: nil, methods: nil, **options)
        model = SinatraDoc.models.find{|x| x.ref == ref.to_sym }
        raise ArgumentError, "No model found with that ref" if model.nil?
        model.attributes.each do |prop_name, meta|
          next if only.is_a?(Array) && !only.include?(prop_name)
          prop(prop_name, meta[:type], meta[:description], options)
        end
        return unless methods.is_a?(Array)
        model.methods.each do |method_name, prop|
          next unless methods.include?(method_name)
          push_prop(prop)
        end
      end

      def prop_template(name, only: nil)
        template = SinatraDoc.prop_templates.find{|x| x.name == name }
        raise ArgumentError, "No prop template found with that name" if template.nil?
        template.props.each do |prop|
          next if only.is_a?(Array) && !only.include?(prop.name)
          push_prop(prop)
        end
      end

      def push_prop(prop)
        @props.delete_if{|x| x.name == prop.name }
        @props << prop
      end
    end

    class Prop
      include PropMethods

      attr_reader :name, :type, :format, :description, :required, :of

      def initialize(name, type, description = nil, **options)
        @name = name
        @type = type.to_sym
        @format = options[:format]&.to_sym
        @description = description
        @required = options[:required] || false
        @of = options[:of]&.to_sym
        @props = []
        validate
      end

      def sub_props_allowed
        return false unless @type == :object || (@type == :array && @of == :object)
        true
      end

      def adapt(adapter)
        case @type
        when :object
          adapter.object_prop(self)
        when :array
          adapter.array_prop(self)
        else
          adapter.basic_prop(self)
        end
      end

      def validate
        validation_type_valid
        validation_of_set_when_type_array
        validation_of_not_set_when_type_no_array
        validation_of_valid unless @of.nil?
      end

      private

      def validation_type_valid
        raise ArgumentError, "Invalid prop type" unless PropTypes.values.include?(@type)
      end

      def validation_of_set_when_type_array
        raise ArgumentError, "Param `of` must be defined when `type` is array" if @type == :array && @of.nil?
      end

      def validation_of_not_set_when_type_no_array
        raise ArgumentError, "Param `of` must not be set when `type` not array" if @type != :array && !@of.nil?
      end

      def validation_of_valid
        raise ArgumentError, "Param `of` must be a valid prop type" unless PropTypes.values.include?(@of)
      end
    end

    class PropTemplate
      include PropMethods

      attr_reader :name

      def initialize(name)
        @name = name
        @props = []
      end
    end
  end
end
