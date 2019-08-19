module SinatraDoc
  class Endpoint
    class Response
      module PropMethods
        def prop(name, type, description = nil, of: nil, &block)
          prop = Prop.new(name, type, description, of: of)
          raise ArgumentError, "Param `of` must be defined when `type` is array" if type == :array && of.nil?
          if block_given?
            raise ArgumentError, "Block given but not being used" unless type == :object ||
                                                                         (type == :array && of == :object)
            prop.instance_eval(&block)
          end
          @props << prop
        end
      end

      class Prop
        include PropMethods

        attr_reader :name, :type, :description

        def initialize(name, type, description, of: nil)
          @name = name
          @type = type
          @description = description
          @of = of
          @props = []
        end
      end
    end
  end
end
