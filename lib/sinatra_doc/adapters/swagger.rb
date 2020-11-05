module SinatraDoc
  module Adapters
    class Swagger < SinatraDoc::Adapter
      class << self
        def core
          core = {
            swagger: "2.0",
            info: {
              title: SinatraDoc.title || "",
              description: SinatraDoc.description || "",
              version: SinatraDoc.version || "1.0.0"
            },
            tags: SinatraDoc.tags.map(&:compact),
            paths: adapt_array(SinatraDoc.endpoints, deep: true),
            securityDefinitions: { JWT: { description: "", type: "apiKey", name: "Authorization", in: "header" } },
            security: [ { "JWT": [] } ]
          }
          core[:host] = SinatraDoc.host unless SinatraDoc.host.nil?
          core[:schemes] = SinatraDoc.schemes unless SinatraDoc.schemes.nil?
          core
        end

        def endpoint(endpoint)
          path = endpoint.available_path_params.each_with_object(endpoint.path) do |param, outcome|
            outcome.gsub!(":#{param}", "{#{param}}")
          end
          {
            "#{path}": {
              "#{endpoint.method.downcase}": {
                tags: endpoint.tags,
                description: endpoint.description,
                consumes: [ endpoint.consumes_value ],
                produces: [ "application/json" ],
                parameters: [].concat(endpoint.path_params.adapt(self))
                              .concat(endpoint.url_params.adapt(self))
                              .concat(endpoint.body_params(auto_initialize: false).nil? ? [] : [ endpoint.body_params.adapt(self, consumes: endpoint.consumes) ].flatten),
                responses: adapt_array(endpoint.responses)
              }.compact
            }
          }
        end

        def path_params(params, **_options)
          params.props.map{|param| move_prop_name_inside(param.adapt(self)).merge(in: :path, required: true) }
        end

        def url_params(params, **_options)
          params.props.map{|param| move_prop_name_inside(param.adapt(self)).merge(in: :query) }
        end

        def body_params(params, **options)
          if options[:consumes] == :form_data
            params.props.map{|param| move_prop_name_inside(param.adapt(self)).merge(in: :formData) }
          else
            props = adapt_array(params.props)
            required_props = []
            props.each do |prop_key, prop_value|
              if prop_value.key?(:required) && prop_value[:required] == true
                required_props << prop_key
                props[prop_key] = prop_value.reject{|key, _val| key == :required }
              end
            end
            {
              name: :body,
              in: :body,
              required: true,
              schema: {
                type: :object,
                properties: props,
                required: required_props.count.positive? ? required_props : nil
              }.compact
            }
          end
        end

        def response(response)
          {
            "#{response.code}": {
              description: response.description || ""
            }.merge(handle_schema_object(response.props))
          }
        end

        def basic_prop(prop)
          {
            "#{prop.name}": {
              type: prop.type,
              format: prop.format,
              description: prop.description,
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
          map = { url: "query", body: "body" }
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

        def adapt_array(array, deep: false)
          array.reduce({}){|accumulator, item| accumulator.send(deep ? :deep_merge : :merge, item.adapt(self)) }
        end

        def move_prop_name_inside(adapted_prop)
          adapted_prop.map{|k, v| { name: k }.merge(v) }[0]
        end
      end
    end
  end
end
