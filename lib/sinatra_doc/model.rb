module SinatraDoc
  module Model
    extend ActiveSupport::Concern

    included do
      SinatraDoc.add_model(self)
      doc_ref(self.to_s.demodulize.tableize.singularize)
    end

    class_methods do
      def doc_ref(value = nil)
        @doc_ref = value if value
        @doc_ref
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
    end
  end
end
