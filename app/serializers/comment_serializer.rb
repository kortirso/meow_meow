class CommentSerializer < ActiveModel::Serializer
    attributes :id, :body, :created_at, :updated_at, :user_id, :pet_id
end
