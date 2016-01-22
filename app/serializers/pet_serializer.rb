class PetSerializer < ActiveModel::Serializer
    attributes :id, :name, :caption, :created_at, :updated_at, :user_id

    class WithComments < self
        has_many :comments
    end
end
