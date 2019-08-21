module SinatraDoc
  class Endpoint
    module PropMethods
      attr_reader :props

      def prop(name, type, description = nil, **options, &block)
        options[:parent_class] = self.class
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
          prop(prop_name, meta[:type], meta[:description], options)
        end
      end

      def push_prop(prop)
        @props.delete_if{|x| x.name == prop.name }
        @props << prop
      end
    end

    class Prop
      include PropMethods

      attr_reader :name, :type, :description, :required, :in

      def initialize(name, type, description, **options)
        @parent_class = options[:parent_class]
        @name = name
        @type = type.to_sym
        @description = description
        @required = options[:required] || false
        @of = options[:of]&.to_sym
        @in = options[:in]&.to_sym
        @props = []
        validate
      end

      def sub_props_allowed
        return false unless @type == :object || (@type == :array && @of == :object)
        true
      end

      def adapt(adapter)
        adapter.basic_prop(self)
      end

      def validate
        validation_type_valid
        validation_of_set_when_type_array
        validation_of_not_set_when_type_no_array
        validation_of_valid unless @of.nil?
        validation_in_only_top_level_params
        validation_in_set if @parent_class == ParamCollection
        validation_in_values if @parent_class == ParamCollection
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

      def validation_in_only_top_level_params
        raise ArgumentError, "Param `in` can only be set on top level endpoint param props" if !@in.nil? && @parent_class != ParamCollection
      end

      def validation_in_set
        raise ArgumentError, "Param `in` must be set on top level endpoint param props" if @in.nil?
      end

      def validation_in_values
        values = [ :url, :body ]
        return if values.include?(@in)
        raise ArgumentError, "Param `in` must be one of the following values: #{values.join(", ")}"
      end
    end
  end
end
