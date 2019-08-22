module SinatraDoc
  module Adapters
    class Swagger < SinatraDoc::Adapter
      class << self
        def basic_prop(prop)
          {
            "#{prop.name}": {
              type: prop.type,
              description: prop.description,
              in: convert_prop_in(prop.in),
              required: prop.required ? true : nil
            }.compact
          }
        end

        def object_prop(prop)
          basic_prop(prop).deep_merge(
            "#{prop.name}": {
              properties: handle_sub_props(prop.props)
            }
          )
        end

        def array_prop(prop)
          basic_prop(prop).deep_merge(
            "#{prop.name}": {
              items: {
                type: prop.of,
                properties: prop.of == :object ? handle_sub_props(prop.props) : nil
              }.compact
            }
          )
        end

        # ----------------------------------------------------------------------
        # Helpers
        # ----------------------------------------------------------------------

        def convert_prop_in(value)
          map = { url: "path", body: "body" }
          map[value]
        end

        def handle_sub_props(props)
          props.reduce({}){|accumulator, prop| accumulator.merge(prop.adapt(self)) }
        end
      end
    end
  end
end
