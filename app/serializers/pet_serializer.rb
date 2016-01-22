class PetSerializer < ActiveModel::Serializer
    attributes :id, :name, :caption, :created_at, :updated_at
    has_many :comments
    has_one :user
end
