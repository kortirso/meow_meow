describe 'Pets API' do
    describe 'GET /index' do
        it_behaves_like 'API Authenticable'

        context 'authorized' do
            let(:me) { create :user }
            let(:access_token) { create :access_token, resource_owner_id: me.id }
            let!(:pets) { create_list(:pet, 2) }
            let(:pet) { pets.first }
            let!(:comment) { create :comment, pet: pet }

            before { get '/api/v1/pets', format: :json, access_token: access_token.token }

            it 'returns 200 status code' do
                expect(response).to be_success
            end

            it 'returns list of pets' do
                expect(response.body).to have_json_size(2).at_path('pets')
            end

            %w(id name caption created_at updated_at).each do |attr|
                it "pet object contains #{attr}" do
                    expect(response.body).to be_json_eql(pet.send(attr.to_sym).to_json).at_path("pets/0/#{attr}")
                end
            end
        end

        def do_request(options = {})
            get '/api/v1/pets', { format: :json }.merge(options)
        end
    end

    describe 'GET /show' do
        let(:pet) { create :pet }
        let!(:comment) { create :comment, pet: pet }

        it_behaves_like 'API Authenticable'

        context 'authorized' do
            let(:me) { create :user }
            let(:access_token) { create :access_token, resource_owner_id: me.id }

            before { get "/api/v1/pets/#{pet.id}", format: :json, access_token: access_token.token }

            it 'returns 200 status code' do
                expect(response).to be_success
            end

            it 'returns one pet' do
                expect(response.body).to have_json_size(1)
            end

            %w(id name caption created_at updated_at user_id).each do |attr|
                it "pet object contains #{attr}" do
                    expect(response.body).to be_json_eql(pet.send(attr.to_sym).to_json).at_path("pet/#{attr}")
                end
            end

            context 'comments' do
                it 'included in pet object' do
                    expect(response.body).to have_json_size(1).at_path('pet/comments')
                end

                %w(id body created_at updated_at user_id).each do |attr|
                    it "contains #{attr}" do
                        expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("pet/comments/0/#{attr}")
                    end
                end
            end
        end

        def do_request(options = {})
            get "/api/v1/pets/#{pet.id}", { format: :json }.merge(options)
        end
    end

    describe 'POST /create' do
        it_behaves_like 'API Authenticable'

        context 'authorized' do
            let(:me) { create :user }
            let(:access_token) { create :access_token, resource_owner_id: me.id }

            context 'with valid attributes' do
                it 'returns 200 status code' do
                    post '/api/v1/pets', pet: attributes_for(:pet), format: :json, access_token: access_token.token

                    expect(response).to be_success
                end

                it 'saves the new pet in the DB and it belongs to current user' do
                    expect { post '/api/v1/pets', pet: attributes_for(:pet), format: :json, access_token: access_token.token }.to change(me.pets, :count).by(1)
                end
            end

            context 'with invalid attributes' do
                it 'doesnt return 200 status code' do
                    post '/api/v1/pets', pet: attributes_for(:pet, :invalid), format: :json, access_token: access_token.token

                    expect(response).to_not be_success
                end

                it 'doesnt save the new pet in the DB' do
                    expect { post '/api/v1/pets', pet: attributes_for(:pet, :invalid), format: :json, access_token: access_token.token }.to_not change(Pet, :count)
                end
            end
        end

        def do_request(options = {})
            post '/api/v1/pets', { format: :json }.merge(options)
        end
    end
end