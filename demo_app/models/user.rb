module DB
  class User < ActiveRecord::Base
    include SinatraDoc::Model

    doc_attribute :id, type: :integer, description: "The id of the user"
    doc_attribute :first_name, type: :string, description: "The users first name"
    doc_attribute :email, type: :string, description: "The users email"
  end
end
