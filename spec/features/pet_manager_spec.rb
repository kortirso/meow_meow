require_relative 'feature_helper'

RSpec.feature 'Pet management', type: :feature do
    describe 'Unauthorized user' do
        let!(:pet) { create :pet }
        let!(:comment) { create :comment, pet: pet }
        let!(:pets) { create_list(:pet, 2) }

        it 'can view all pets' do
            visit pets_path

            expect(page).to have_content pets[0].name
            expect(page).to have_content pets[1].name
        end

        it 'cant creates a pet' do
            visit pets_path

            expect(page).to_not have_content 'Add pet'
        end

        it 'can view pet and its comments' do
            visit pet_path(pet)

            expect(page).to have_content pet.name
            expect(page).to have_content comment.body
        end

        it 'cant comment pet' do
            visit pet_path(pet)

            expect(page).to_not have_content 'Put your comment for this pet'
        end

        it 'cant delete pets' do
            visit pet_path(pet)

            expect(page).to_not have_content 'Delete pet'
        end
    end

    describe 'Logged user' do
        let!(:user_1) { create :user }
        let!(:user_2) { create :user }
        let!(:pet_1) { create :pet, user: user_1 }
        let!(:pet_2) { create :pet, user: user_2 }
        let!(:comment_1) { create :comment, pet: pet_1, user: user_1 }
        let!(:comment_2) { create :comment, pet: pet_2, user: user_2 }
        before do
            sign_in user_1
        end

        context 'can try creates a pet' do
            before do
                visit pets_path
                click_on 'Add pet'
            end

           it 'with valid data' do
                fill_in 'pet_name', with: pet_1.name
                fill_in 'pet_caption', with: pet_1.caption
                click_on 'Submit'

                expect(page).to have_content pet_1.name
                expect(page).to have_content pet_1.caption
            end

            it 'with invalid data' do
                fill_in 'pet_name', with: pet_1.name
                click_on 'Submit'

                expect(page).to have_css '#new_pet .has-error'
            end
        end

        context 'can try comment pet' do
            it 'with valid data', js: true do
                visit pet_path(pet_1)

                fill_in 'comment_body', with: 'testing'
                click_on 'Comment'

                within '#comments' do
                    expect(page).to have_content 'testing'
                end
            end
        end

        context 'can delete own data like' do
            it 'pet' do
                visit pets_path
                within "#pet_#{pet_1.id}" do
                    click_on 'Destroy'
                end
                
                expect(page).to_not have_css "pet_#{pet_1.id}"
            end

            it 'comment', js: true do
                visit pet_path(pet_1)
                within "#comment_#{comment_1.id}" do
                    click_on 'Delete comment'

                    expect(page).to_not have_css "comment_#{comment_1.id}"
                end
            end
        end

        context 'cant delete data of other users like' do
            it 'pet' do
                visit pets_path

                within "#pet_#{pet_2.id}" do
                    expect(page).to_not have_content 'Destroy'
                end
            end

            it 'comment' do
                visit pet_path(pet_2)

                within "#comment_#{comment_2.id}" do
                    expect(page).to_not have_content 'Delete comment'
                end
            end
        end
    end
end