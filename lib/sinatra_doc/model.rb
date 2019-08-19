module SinatraDoc
  module Model
    extend ActiveSupport::Concern

    included do
      SinatraDoc.add_model(self)
      doc_ref(self.to_s.demodulize.tableize.singularize)
    end

    class_methods do
      attr_reader :doc_attributes

      def doc_ref(value = nil)
        @doc_ref = value if value
        @doc_ref
      end

      def doc_attribute(name, type: nil, description: nil)
        @doc_attributes ||= {}
        @doc_attributes[name.to_sym] = { type: type, description: description }
      end
    end
  end

  class ModelProxy
    attr_reader :klass

    def initialize(klass)
      @klass = klass
      @ref = nil
      process
    end

    private

    def process
      @ref = @klass.doc_ref
      process_attributes
    end

    def process_attributes
      @attributes = @klass.column_names.map{|x| [ x.to_sym, { type: :string, description: nil } ] }.to_h
      @attributes.merge!(@klass.doc_attributes)
    end
  end
end
