describe 'Profile API' do
    describe 'GET /me' do
        it_behaves_like 'API Authenticable'

        context 'authorized' do
            let!(:me) { create :user }
            let!(:pet) { create :pet, user: me }
            let!(:comment) { create :comment, user: me }
            let(:access_token) { create :access_token, resource_owner_id: me.id }

            before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

            it 'returns 200 status' do
                expect(response).to be_success
            end

            %w(id email created_at updated_at admin).each do |attr|
                it "contains #{attr}" do
                    expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path("user/#{attr}")
                end
            end

            %w(password encrypted_password).each do |attr|
                it "doesnt contains #{attr}" do
                    expect(response.body).to_not have_json_path(attr)
                end
            end

            context 'comments' do
                it 'included in user object' do
                    expect(response.body).to have_json_size(1).at_path('user/comments')
                end

                %w(id body created_at updated_at user_id).each do |attr|
                    it "contains #{attr}" do
                        expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("user/comments/0/#{attr}")
                    end
                end
            end

            context 'pets' do
                it 'included in user object' do
                    expect(response.body).to have_json_size(1).at_path('user/pets')
                end

                %w(id name caption created_at updated_at user_id).each do |attr|
                    it "contains #{attr}" do
                        expect(response.body).to be_json_eql(pet.send(attr.to_sym).to_json).at_path("user/pets/0/#{attr}")
                    end
                end
            end
        end

        def do_request(options = {})
            get '/api/v1/profiles/me', { format: :json }.merge(options)
        end
    end

    describe 'GET /all' do
        it_behaves_like 'API Authenticable'

        context 'authorized' do
            let!(:me) { create :user }
            let!(:users) { create_list(:user, 2) }
            let!(:access_token) { create :access_token, resource_owner_id: me.id }

            before { get '/api/v1/profiles/all', format: :json, access_token: access_token.token }

            it 'returns 200 status' do
                expect(response).to be_success
            end

            it 'contains other user data' do
                expect(response.body).to be_json_eql(users.to_json).at_path('profiles')
            end

            it 'and doesnt contain me data' do
                expect(response.body).to_not include_json(me.to_json)
            end
        end

        def do_request(options = {})
            get '/api/v1/profiles/all', { format: :json }.merge(options)
        end
    end
end