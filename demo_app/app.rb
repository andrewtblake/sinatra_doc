require "sinatra"
require "active_record"
require "../lib/sinatra_doc"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "./db.sqlite")

Dir["./models/**/*.rb"].each{|file| require file }

SinatraDoc.response_template :create do
  prop :message, :string, "A message telling you what has been created"
end

SinatraDoc.response_template :not_found, code: 404 do
  prop :message, :string, "A message explaining that the resource has not been found"
end

doc do
  tags [ "Misc" ]
  description "The index route of this API"
  response code: 200 do
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
    prop :model_array_property, :array, of: :object do
      model :user, only: [ :id, :email ]
      prop :another_key, :string, "This is another key that will come back with the model"
    end
  end
  response :create, code: 201 do
    prop :additional_property, :string, "An additional property on top of the template used"
  end
  response :not_found
end
get "/" do
  "Index Route"
end
