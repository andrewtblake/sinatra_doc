module SinatraDoc
  module Adapters
    class Swagger < SinatraDoc::Adapter
      class << self
        def core
          {
            swagger: "2.0",
            info: {
              title: SinatraDoc.title || "",
              description: SinatraDoc.description || "",
              version: SinatraDoc.version || "1.0.0"
            },
            host: SinatraDoc.host,
            schemes: [ :http ],
            tags: SinatraDoc.tags.map{|tag| { name: tag } },
            paths: adapt_array(SinatraDoc.endpoints)
          }
        end

        def endpoint(endpoint)
          {
            "#{endpoint.path}": {
              "#{endpoint.method.downcase}": {
                tags: endpoint.tags,
                description: endpoint.description,
                produces: [ "application/json" ],
                parameters: endpoint.params.adapt(self),
                responses: adapt_array(endpoint.responses)
              }.compact
            }
          }
        end

        def params(params)
          param_array = []
          param_array << handle_body_params(params.props.select{|prop| prop.in == :body })
          param_array
        end

        def response(response)
          {
            "#{response.code}": {
              description: response.description
            }.merge(handle_schema_object(response.props))
          }
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
              properties: adapt_array(prop.props)
            }
          )
        end

        def array_prop(prop)
          basic_prop(prop).deep_merge(
            "#{prop.name}": {
              items: {
                type: prop.of,
                properties: prop.of == :object ? adapt_array(prop.props) : nil
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

        def handle_schema_object(props)
          {
            schema: {
              type: :object,
              properties: adapt_array(props)
            }
          }
        end

        def handle_body_params(params)
          {
            name: :body,
            in: :body,
            required: true,
            schema: {
              type: :object,
              properties: adapt_array(params).transform_values do |prop_val|
                prop_val.reject{|key, _value| key == :in }
              end
            }
          }
        end

        def adapt_array(array)
          array.reduce({}){|accumulator, item| accumulator.merge(item.adapt(self)) }
        end
      end
    end
  end
end
