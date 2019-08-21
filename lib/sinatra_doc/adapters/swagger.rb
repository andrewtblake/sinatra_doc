module SinatraDoc
  module Adapters
    class Swagger < SinatraDoc::Adapter
      class << self
        def basic_prop(prop)
          meta = { type: prop.type, description: prop.description }
          meta[:required] = true if prop.required
          meta[:in] = convert_in(prop.in) unless prop.in.nil?
          { "#{prop.name}": meta }
        end

        # ----------------------------------------------------------------------
        # Helpers
        # ----------------------------------------------------------------------

        def convert_in(value)
          map = { url: "path", body: "body" }
          map[value]
        end
      end
    end
  end
end
