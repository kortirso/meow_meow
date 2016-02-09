class CommentSerializer < ActiveModel::Serializer
    attributes :id, :body, :created_at, :updated_at, :user_id, :pet_id, :author

    def author
        object.user.email
    end
end
