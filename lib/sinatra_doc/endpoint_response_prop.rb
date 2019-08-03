module SinatraDoc
  class Endpoint
    class Response
      class Prop
        attr_reader :name, :type, :description

        def initialize(name, type, description)
          @name = name
          @type = type
          @description = description
        end
      end
    end
  end
end
