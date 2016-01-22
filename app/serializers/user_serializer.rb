class UserSerializer < ActiveModel::Serializer
    attributes :id, :email, :created_at, :updated_at, :admin

    class WithObjects < self
        has_many :comments
        has_many :pets
    end
end
