module SinatraDoc
  module Adapters
    class Swagger < SinatraDoc::Adapter
      class << self
        def endpoint(endpoint)
          {
            "#{endpoint.path}": {
              "#{endpoint.method}": {
                tags: endpoint.tags,
                description: endpoint.description,
                produces: [ "application/json" ],
                parameters: endpoint.params.adapt(self),
                responses: {}
              }.compact
            }
          }
        end

        def params(params)
          param_array = []
          param_array << handle_body_params(params.props.select{|prop| prop.in == :body })
          param_array
        end

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
              properties: handle_props_array(prop.props)
            }
          )
        end

        def array_prop(prop)
          basic_prop(prop).deep_merge(
            "#{prop.name}": {
              items: {
                type: prop.of,
                properties: prop.of == :object ? handle_props_array(prop.props) : nil
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

        def handle_body_params(params)
          {
            name: :body,
            in: :body,
            required: true,
            schema: {
              type: :object,
              properties: handle_props_array(params)
            }
          }
        end

        def handle_props_array(props)
          props.reduce({}){|accumulator, prop| accumulator.merge(prop.adapt(self)) }
        end
      end
    end
  end
end
