module SinatraDoc
  module Model
    extend ActiveSupport::Concern

    included do
      SinatraDoc.add_model(self)
      doc_ref(self.to_s.demodulize.tableize.singularize)
    end

    class_methods do
      def doc_ref(value = nil)
        @doc_ref = value.to_sym if value
        @doc_ref
      end

      def doc_attributes
        @doc_attributes ||= {}
      end

      def doc_attribute(name, type, description = nil, **options, &block)
        doc_attributes
        prop = Endpoint::Prop.new(name, type, description, options)
        if block_given?
          raise ArgumentError, "Block given but not being used" unless prop.sub_props_allowed
          prop.instance_eval(&block)
        end
        @doc_attributes[name.to_sym] = prop
      end

      def doc_methods
        @doc_methods ||= {}
      end

      def doc_method(name, type, description = nil, **options, &block)
        doc_methods
        prop = Endpoint::Prop.new(name, type, description, options)
        if block_given?
          raise ArgumentError, "Block given but not being used" unless prop.sub_props_allowed
          prop.instance_eval(&block)
        end
        @doc_methods[name.to_sym] = prop
      end

      def doc_prop_templates
        @doc_prop_templates ||= []
      end

      def doc_prop_template(name, &block)
        doc_prop_templates
        template = Endpoint::PropTemplate.new(name)
        template.instance_eval(&block) if block_given?
        @doc_prop_templates << template
      end
    end
  end

  class ModelProxy
    attr_reader :klass, :ref, :attributes

    def initialize(klass)
      @klass = klass
      @ref = nil
      process
    end

    def methods
      @klass.doc_methods
    end

    def prop_templates
      @klass.doc_prop_templates
    end

    private

    def process
      @ref = @klass.doc_ref
      process_attributes
    end

    def process_attributes
      unless @klass.connection.data_source_exists?(@klass.table_name)
        @attributes = {}.merge(@klass.doc_attributes)
        return
      end
      @attributes = @klass.columns.map do |column|
        [
          column.name.to_sym,
          Endpoint::Prop.new(
            column.name.to_sym,
            SinatraDoc::Endpoint::PropTypes.convert_type(column.sql_type_metadata.sql_type),
            format: SinatraDoc::Endpoint::PropTypes.get_format_from_type(column.sql_type_metadata.sql_type)
          )
        ]
      end.to_h
      @attributes.merge!(@klass.doc_attributes)
    end
  end
end
