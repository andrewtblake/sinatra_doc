module SinatraDoc
  class Endpoint
    module PropTypes
      MAP = {
        integer: [ "integer", "number", "int", "int32", "int64" ],
        string: [ "string", "str", "text", "txt", "varchar" ],
        boolean: [ "boolean", "bool" ],
        object: [ "object" ],
        array: [ "array" ]
      }.freeze

      class << self
        def values
          MAP.keys
        end

        def convert(sql_type)
          MAP.each do |type, values|
            return type if values.include?(sql_type.downcase)
          end
          :string
        end
      end
    end
  end
end
