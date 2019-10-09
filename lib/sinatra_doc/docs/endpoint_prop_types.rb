module SinatraDoc
  class Endpoint
    module PropTypes
      MAP = {
        integer: [
          { types: [ "integer", "int" ] },
          { types: [ "int32", "integer32" ], format: "int32" },
          { types: [ "int64", "integer64" ], format: "int64" }
        ],
        number: [
          { types: [ "number" ] },
          { types: [ "float", "decimal" ], format: "float" },
          { types: [ "double" ], format: "double" }
        ],
        string: [
          { types: [ "string", "str", "text", "txt", "varchar" ] },
          { types: [ "date" ], format: "date" },
          { types: [ "date-time", "datetime", "timestamp" ], format: "date-time" },
          { types: [ "password", "passwd", "pass" ], format: "password" },
          { types: [ "byte" ], format: "byte" },
          { types: [ "binary" ], format: "binary" }
        ],
        boolean: [
          { types: [ "boolean", "bool" ] }
        ],
        file: [
          { types: [ "file" ] }
        ],
        object: [
          { types: [ "object", "obj", "jsonb", "json" ] }
        ],
        array: [
          { types: [ "array" ] }
        ]
      }.freeze
      TYPES_MAP = MAP.transform_values{|value| value.collect{|x| x[:types] }.flatten }
      FORMATS_MAP = MAP.transform_values{|value| value.collect{|x| x[:format] }.compact }

      class << self
        def values
          MAP.keys
        end

        def convert_type(sql_type)
          TYPES_MAP.each do |type, values|
            return type if values.include?(sql_type.downcase)
          end
          :string
        end

        def get_format_from_type(sql_type)
          MAP.each do |_type, configs|
            configs.each do |config|
              return config[:format] if config[:types].include?(sql_type.downcase)
            end
          end
          nil
        end
      end
    end
  end
end
