require_relative 'feature_helper'

RSpec.feature 'Add comment to pet', type: :feature do
    let!(:user) { create :user }
    let!(:pet) { create :pet }

     describe 'Unauthorized user' do
        it 'cant see add_comment form' do
            visit pet_path(pet)

            expect(page).to_not have_css '#new_comment'
        end
    end

    describe 'Authorized user' do
        before { sign_in user }

        context 'for pet' do
            before { visit pet_path(pet) }

            it 'can see add_comment form' do
                expect(page).to have_css '#new_comment'
            end

            it 'and can add_comment', js: true do
                within '#new_comment' do
                    fill_in 'comment_body', with: 'new comment'
                    click_on 'Comment'
                end
                
                expect(page).to have_content 'new comment'
            end
        end
    end
end