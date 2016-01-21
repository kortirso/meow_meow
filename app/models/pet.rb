class Pet < ActiveRecord::Base
    mount_uploader :image, ImageUploader

    belongs_to :user
    has_many :comments

    validates :name, :caption, :user_id, presence: true
end
