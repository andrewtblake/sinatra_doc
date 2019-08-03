module SinatraDoc
  class Endpoint
    class Response
      module PropMethods
        def prop(name, type, description, &block)
          prop = Prop.new(name, type, description)
          prop.instance_eval(&block) if block_given? && type == :object
          @props << prop
        end
      end

      class Prop
        include PropMethods

        attr_reader :name, :type, :description

        def initialize(name, type, description)
          @name = name
          @type = type
          @description = description
          @props = []
        end
      end
    end
  end
end
