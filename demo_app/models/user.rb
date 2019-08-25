module DB
  class User < ActiveRecord::Base
    include SinatraDoc::Model

    doc_attribute :first_name, :string, "The user's first name"
    doc_attribute :email, :string, "The user's email"
    doc_method :string_method, :string, "A method that returns a string"
    doc_method :object_method, :object, "A method that returns an object" do
      prop :key_1, :string
    end
  end
end
