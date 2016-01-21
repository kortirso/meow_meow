RSpec.describe Pet, type: :model do
    it { should have_many :comments }
    it { should belong_to :user }
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :name }
    it { should validate_presence_of :caption }
end
