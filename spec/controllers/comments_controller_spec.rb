RSpec.describe CommentsController, type: :controller do
    describe 'POST #create' do
        let!(:pet) { create :pet }

        context 'Unauthorized user' do
            it 'cant add comments' do
                expect { post :create, pet_id: pet, comment: attributes_for(:comment), format: :js }.to_not change(pet.comments, :count)
            end
        end

        context 'Authorized user' do
            sign_in_user

            context 'with valid attributes' do
                it 'saves the new comment in the DB and it belongs to pet' do
                    expect { post :create, pet_id: pet, comment: attributes_for(:comment), format: :js }.to change(pet.comments, :count).by(1)
                end
            end

            context 'with invalid attributes' do
                it 'does not save the new comment in the DB' do
                    expect { post :create, pet_id: pet, comment: attributes_for(:comment, :invalid), format: :js }.to_not change(Pet, :count)
                end
            end
        end
    end

    describe 'PATCH #update' do
        let!(:pet) { create :pet }

        context 'Unauthorized user' do
            let!(:comment) { create :comment, pet: pet }

            it 'cant change comment' do
                expect { patch :update, id: comment, pet_id: pet, comment: attributes_for(:comment), format: :js }.to_not change{comment}
            end
        end

        context 'Authorized user can try' do
            sign_in_user
            let!(:comment_1) { create :comment, pet: pet, user: @current_user }
            let!(:comment_2) { create :comment, pet: pet }

            context 'change own comment' do
                it 'assigns the requested comment to @comment' do
                    patch :update, id: comment_1, pet_id: pet, comment: attributes_for(:comment), format: :js

                    expect(assigns(:comment)).to eq comment_1
                end

                it 'with valid attributes changes pet' do
                    patch :update, id: comment_1, pet_id: pet, comment: { body: 'new body' }, format: :js
                    comment_1.reload

                    expect(comment_1.body).to eq 'new body'
                end

                it 'with invalid attributes doesnt changes pet' do
                    expect { patch :update, id: comment_1, pet_id: pet, comment: { body: '' }, format: :js }.to_not change(comment_1, :body)
                end
            end

            context 'change pet of other user' do
                it 'but not update pet' do
                    expect { patch :update, id: comment_2, pet_id: pet, comment: { body: 'new body' }, format: :js }.to_not change(comment_2, :body)
                end
            end
        end
    end

    describe 'POST #destroy' do
        sign_in_user
        let!(:pet) { create :pet }
        let!(:comment_1) { create :comment, pet: pet, user: @current_user }
        let!(:comment_2) { create :comment, pet: pet }

        context 'own comment' do
            it 'deletes comment from pet' do
                expect { delete :destroy, id: comment_1, pet_id: pet, format: :js }.to change(pet.comments, :count).by(-1)
            end

            it 'deletes comment from user' do
                expect { delete :destroy, id: comment_1, pet_id: pet, format: :js }.to change(@current_user.comments, :count).by(-1)
            end
        end

        context 'comment of other user' do
            it 'not delete comment' do
                expect { delete :destroy, id: comment_2, pet_id: pet, format: :js }.to_not change(pet.comments, :count)
            end

            it 'redirects to root_path' do
                delete :destroy, id: comment_2, pet_id: pet, format: :js

                expect(response).to redirect_to root_path
            end
        end
    end
end
