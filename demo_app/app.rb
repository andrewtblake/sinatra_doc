require "sinatra"
require "../lib/sinatra_doc"

doc do
  tags [ "Misc" ]
  description "The index route of this API"
  response 200 do
    prop :standard_property, :string, "This is an example of a standard property"
    prop :object_property, :object, "This is an example of an object property" do
      prop :key_1, :integer, "Key one of the object"
      prop :key_2, :string, "Key two of the object"
      prop :key_3, :object, "Key three of the object. A sub-object property" do
        prop :sub_key_1, :integer, "Key one of the sub-object"
      end
    end
    prop :basic_array_property, :array, "An array of strings", of: :string
    prop :object_array_property, :array, of: :object do
      prop :key_1, :integer, "Key one of the object"
    end
  end
end
get "/" do
  "Index Route"
end
