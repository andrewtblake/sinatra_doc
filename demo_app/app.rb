require "sinatra"
require "active_record"
require "../lib/sinatra_doc"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "./db.sqlite")

Dir["./models/**/*.rb"].each{|file| require file }

SinatraDoc.host = "google.com"
SinatraDoc.title = "Demo Application"
SinatraDoc.description = "This is the description for the demo application"
SinatraDoc.register_tag("Misc")
SinatraDoc.register_tag("Misc Post", description: "A random tag")
SinatraDoc.response_template :create do
  prop :message, :string, "A message telling you what has been created"
end
SinatraDoc.response_template :not_found, code: 404 do
  prop :message, :string, "A message explaining that the resource has not been found"
end

doc do
  tags [ "Misc" ]
  description "The index route of this API"
  params do
    prop :url_param_1, :string, "The first url param", required: true, in: :url
    prop :url_param_2, :string, "The second url param", in: :url
    prop :body_param_1, :string, "The first body param", in: :body, required: true
    prop :body_param_2, :integer, "The second body param", in: :body
    prop :body_object_param, :object, in: :body do
      prop :key_1, :string, "First object property"
    end
    model :user, only: [ :first_name, :last_name, :email ], in: :body, required: true
  end
  response code: 200, description: "Success Response" do
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

doc do
  tags [ "Misc Post" ]
  description "A post method route endpoint"
  params do
    prop :test, :string, in: :body
  end
  response code: 200 do
    prop :message, :string
  end
end
post "/" do
  "Post Index Route"
end
