module SinatraDoc
  module SqlTypeConverter
    MAP = {
      integer: [ "integer", "number", "int", "int32", "int64" ],
      string: [ "string", "str", "text", "txt", "varchar" ],
      boolean: [ "boolean", "bool" ]
    }.freeze

    class << self
      def lookup(sql_type)
        MAP.each do |type, values|
          return type if values.include?(sql_type.downcase)
        end
        :string
      end
    end
  end
end
