module DB
  class User < ActiveRecord::Base
    include SinatraDoc::Model

    doc_attribute :first_name, type: :string, description: "The user's first name"
    doc_attribute :email, type: :string, description: "The user's email"
  end
end
