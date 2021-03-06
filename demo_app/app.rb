require "sinatra"
require "active_record"
require "../lib/sinatra_doc"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "./db.sqlite")

Dir["./models/**/*.rb"].each{|file| require file }

SinatraDoc.configure do
  self.host = "localhost:9292"
  self.title = "Demo Application"
  self.description = "This is the description for the demo application"
  register_tag("Misc")
  register_tag("Misc Post", description: "A random tag")
  prop_template :pagination do
    prop :page, :integer, "The page number of results you would like to see"
    prop :size, :integer, "The number of results that should be returned for each page"
  end
  response_template :create do
    prop :message, :string, "A message telling you what has been created"
  end
  response_template :not_found, code: 404 do
    prop :message, :string, "A message explaining that the resource has not been found"
  end
end

doc do
  tags [ "Misc" ]
  description "The index route of this API"
  params in: :url do
    prop_template :pagination
    prop :url_param_1, :string, "The first url param", required: true
    prop :url_param_2, :string, "The second url param"
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
      model :user, only: [ :id, :email ], methods: [ :string_method, :object_method ]
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
  params in: :url do
    prop_template :pagination, only: [ :page ]
  end
  params in: :body do
    prop :body_param_1, :string, "The first body param", required: true
    prop :body_param_2, :integer, "The second body param"
    prop :body_object_param, :object do
      prop :key_1, :string, "First object property"
    end
    model :user, only: [ :first_name, :last_name, :email ], methods: [ :string_method ], required_props: [ :first_name, :last_name, :email, :string_methods ]
  end
  params in: :body do
    prop :test, :string, format: "date"
  end
  response code: 200 do
    prop :message, :string
  end
end
post "/" do
  "Post Index Route"
end

doc do
  tags [ "Misc" ]
  description "Another request but with path params"
  params in: :path do
    model :user, only: [ :id ], rename_props: { id: :user_id }
    prop :company_id, :integer, "The id of the company you wish to interact with"
  end
  response code: 200 do
    prop :message, :string
    prop :string_with_format, :string, format: "date-time"
    model :user, only: [ :telephone ]
  end
end
get "/users/:user_id/companies/:company_id" do
  JSON.generate(message: "Another Endpoint")
end
