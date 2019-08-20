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
          push_prop(prop)
        end

        def model(ref, only: nil)
          model = SinatraDoc.models.find{|x| x.ref == ref.to_sym }
          model.attributes.each do |prop_name, meta|
            next if only.is_a?(Array) && !only.include?(prop_name)
            push_prop(Prop.new(prop_name, meta[:type], meta[:description]))
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
