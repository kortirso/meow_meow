class Pet < ActiveRecord::Base
    belongs_to :user
    has_many :comments

    validates :name, :caption, :user_id, presence: true
end
