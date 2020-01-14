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

      def prop_template(name, only: nil)
        template = SinatraDoc.prop_templates.find{|x| x.name == name }
        raise ArgumentError, "No prop template found with that name" if template.nil?
        template.props.each do |prop|
          next if only.is_a?(Array) && !only.include?(prop.name)
          push_prop(prop)
        end
      end

      def model(ref, only: nil, except: nil, methods: nil, required_props: nil, rename_props: nil)
        model = SinatraDoc.models.find{|x| x.ref.to_sym == ref.to_sym }
        raise ArgumentError, "No model found with that ref" if model.nil?
        model.attributes.each do |prop_name, prop|
          next if only.is_a?(Array) && !only.include?(prop_name)
          next if except.is_a?(Array) && except.include?(prop_name)
          dup_prop = prop.dup
          dup_prop.update_required(true) if required_props.is_a?(Array) && required_props.include?(prop_name)
          dup_prop.update_name(rename_props[prop_name]) if rename_props.is_a?(Hash) && rename_props.key?(prop_name)
          push_prop(dup_prop)
        end
        model.methods.each do |method_name, prop|
          next if !methods.is_a?(Array) || !methods.include?(method_name)
          dup_prop = prop.dup
          dup_prop.update_required(true) if required_props.is_a?(Array) && required_props.include?(method_name)
          dup_prop.update_name(rename_props[prop_name]) if rename_props.is_a?(Hash) && rename_props.key?(method_name)
          push_prop(dup_prop)
        end
      end

      def model_prop_template(ref, name, only: nil)
        model = SinatraDoc.models.find{|x| x.ref == ref.to_sym }
        raise ArgumentError, "No model found with that ref" if model.nil?
        template = model.prop_templates.find{|x| x.name == name }
        raise ArgumentError, "No prop template found with that ref and name" if template.nil?
        template.props.each do |prop|
          next if only.is_a?(Array) && !only.include?(prop.name)
          push_prop(prop)
        end
      end

      def push_prop(prop)
        @props.delete_if{|x| x.name == prop.name }
        @props << prop
      end

      def full_clone
        cloned = self.clone
        cloned.instance_eval{ @props = @props.map(&:full_clone) }
        cloned
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

      def update_name(value)
        raise ArgumentError, "Prop `name` must be a string or symbol" unless [ String, Symbol ].include?(value.class)
        @name = value
        validate
      end

      def update_required(value)
        raise ArgumentError, "Prop `required` must be a boolean" unless [ TrueClass, FalseClass ].include?(value.class)
        @required = value
        validate
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
        validation_format_valid unless @format.nil?
        validation_of_set_when_type_array
        validation_of_not_set_when_type_no_array
        validation_of_valid unless @of.nil?
      end

      private

      def validation_type_valid
        raise ArgumentError, "Invalid prop type" unless PropTypes.values.include?(@type)
      end

      def validation_format_valid
        raise ArgumentError, "Invalid prop format" unless PropTypes::FORMATS_MAP[@type].include?(@format.to_s)
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
