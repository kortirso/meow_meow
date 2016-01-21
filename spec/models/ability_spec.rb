RSpec.describe Ability, type: :model do
    subject(:ability) { Ability.new(user) }

    describe 'for guest' do
        let(:user) { nil }

        it { should be_able_to :read, :all }

        it { should_not be_able_to :create, :all }
        it { should_not be_able_to :update, :all }
        it { should_not be_able_to :destroy, :all }
        it { should_not be_able_to :manage, :all }
    end

    describe 'for admin' do
        let(:user) { create :user, :admin }

        it { should be_able_to :manage, :all }
    end

    describe 'for user' do
        let!(:user) { create :user }
        let!(:other_user) { create :user }
        let!(:pet) { create :pet, user: user }
        let!(:other_pet) { create :pet, user: other_user }
        let!(:comment) { create :comment, pet: pet, user: user }
        let!(:other_comment) { create :comment, pet: other_pet, user: other_user }

        it { should be_able_to :read, :all }
        it { should be_able_to :create, :all }

        it { should be_able_to :update, pet, user: user }
        it { should be_able_to :update, comment, user: user }
        it { should_not be_able_to :update, other_pet, user: user }
        it { should_not be_able_to :update, other_comment, user: user }

        it { should be_able_to :destroy, pet, user: user }
        it { should be_able_to :destroy, comment, user: user }
        it { should_not be_able_to :destroy, other_pet, user: user }
        it { should_not be_able_to :destroy, other_comment, user: user }

        it { should_not be_able_to :manage, :all }
    end
end