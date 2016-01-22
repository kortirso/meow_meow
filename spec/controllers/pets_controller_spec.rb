RSpec.describe PetsController, type: :controller do
    describe 'GET #index' do
        let(:pets) { create_list(:pet, 2) }
        before { get :index }

        it 'collect an array of all pets' do
            expect(assigns(:pets)).to match_array(pets)
        end

        it 'renders index view' do
            expect(response).to render_template :index
        end
    end

    describe 'GET #show' do
        let(:pet) { create :pet }
        before { get :show, id: pet }

        it 'assigns the requested pet to @pet' do
            expect(assigns(:pet)).to eq pet
        end

        it 'assigns new comment to pet' do
            expect(assigns(:comment)).to be_a_new(Comment)
        end

        it 'renders show view' do
            expect(response).to render_template :show
        end
    end

    describe 'GET #new' do
        sign_in_user
        before { get :new }

        it 'assigns a new pet to @pet' do
            expect(assigns(:pet)).to be_a_new(Pet)
        end

        it 'renders new view' do
            expect(response).to render_template :new
        end
    end

    describe 'POST #create' do
        sign_in_user

        context 'with valid attributes' do
            it 'saves the new pet in the DB and it belongs to current user' do
                expect { post :create, pet: attributes_for(:pet) }.to change(@current_user.pets, :count).by(1)
            end

            it 'redirects to show view' do
                post :create, pet: attributes_for(:pet)

                expect(response).to redirect_to pet_path(assigns(:pet))
            end
        end

        context 'with invalid attributes' do
            it 'does not save the new pet in the DB' do
                expect { post :create, pet: attributes_for(:pet, :invalid) }.to_not change(Pet, :count)
            end

            it 're-render new view' do
                post :create, pet: attributes_for(:pet, :invalid)

                expect(response).to render_template :new
            end
        end
    end

    describe 'GET #edit' do
        context 'Unauthorized user' do
            let!(:pet) { create :pet }

            it 'cant change pet' do
                expect { patch :update, id: pet, pet: attributes_for(:pet) }.to_not change{pet}
            end
        end

        context 'Authorized user can try' do
            sign_in_user
            before { get :edit, id: pet }

            context 'change own pet' do
                let!(:pet) { create :pet, user: @current_user }

                it 'assigns the requested pet to @pet' do
                    expect(assigns(:pet)).to eq pet
                end

                it 'renders edit form' do
                    expect(response).to render_template :edit
                end
            end

            context 'change pet of other user' do
                let!(:pet) { create :pet }
                
                it 'but redirect to root_path' do
                    expect(response).to redirect_to root_path
                end
            end
        end
    end

    describe 'PATCH #update' do
        context 'Unauthorized user' do
            let!(:pet) { create :pet }

            it 'cant change pet' do
                expect { patch :update, id: pet, pet: attributes_for(:pet) }.to_not change{pet}
            end
        end

        context 'Authorized user can try' do
            sign_in_user
            let!(:pet_1) { create :pet, user: @current_user }
            let!(:pet_2) { create :pet }

            context 'change own pet' do
                it 'assigns the requested pet to @pet' do
                    patch :update, id: pet_1, pet: attributes_for(:pet)

                    expect(assigns(:pet)).to eq pet_1
                end

                it 'with valid attributes changes pet' do
                    patch :update, id: pet_1, pet: { name: 'new name', caption: 'new caption' }
                    pet_1.reload

                    expect(pet_1.name).to eq 'new name'
                    expect(pet_1.caption).to eq 'new caption'
                end

                it 'with invalid attributes doesnt changes pet' do
                    expect { patch :update, id: pet_1, pet: { name: '' } }.to_not change(pet_1, :name)
                    expect { patch :update, id: pet_1, pet: { caption: '' } }.to_not change(pet_1, :caption)
                end
            end

            context 'change pet of other user' do
                it 'but not update pet' do
                    expect { patch :update, id: pet_2, pet: { name: 'new name' } }.to_not change(pet_2, :name)
                    expect { patch :update, id: pet_2, pet: { caption: 'new caption' } }.to_not change(pet_2, :caption)
                end
            end
        end
    end

    describe 'POST #destroy' do
        sign_in_user
        let!(:pet_1) { create :pet, user: @current_user }
        let!(:pet_2) { create :pet }

        context 'own pet' do
            it 'deletes pet' do
                expect { delete :destroy, id: pet_1 }.to change(Pet, :count).by(-1)
            end

            it 'and redirects to pets path' do
                delete :destroy, id: pet_1

                expect(response).to redirect_to pets_path
            end
        end

        context 'pet of other user' do
            it 'not delete pet' do
                expect { delete :destroy, id: pet_2 }.to_not change(Pet, :count)
            end

            it 'redirects to root_path' do
                delete :destroy, id: pet_2

                expect(response).to redirect_to root_path
            end
        end
    end
end
