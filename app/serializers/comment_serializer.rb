class CommentSerializer < ActiveModel::Serializer
    attributes :id, :body, :author

    def author
        object.user.email
    end

    class Full < self
        attributes :created_at, :updated_at, :user_id, :pet_id
    end
end
