class Comment < ActiveRecord::Base
    belongs_to :user
    belongs_to :pet

    validates :body, :user_id, :pet_id, presence: true
end
