describe 'Comments API' do
    describe 'GET /index' do
        let(:pet) { create :pet }

        it_behaves_like 'API Authenticable'

        context 'authorized' do
            let(:me) { create :user }
            let(:access_token) { create :access_token, resource_owner_id: me.id }
            let!(:comments) { create_list(:comment, 2, pet: pet) }
            let(:comment) { comments.first }

            before { get "/api/v1/pets/#{pet.id}/comments", format: :json, access_token: access_token.token }

            it 'returns 200 status code' do
                expect(response).to be_success
            end

            it 'returns list of comments' do
                expect(response.body).to have_json_size(2).at_path('comments')
            end

            %w(id body created_at updated_at user_id pet_id).each do |attr|
                it "comment object contains #{attr}" do
                    expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
                end
            end
        end

        def do_request(options = {})
            get "/api/v1/pets/#{pet.id}/comments", { format: :json }.merge(options)
        end
    end

    describe 'GET /show' do
        let(:pet) { create :pet }
        let!(:comment) { create :comment, pet: pet }

        it_behaves_like 'API Authenticable'

        context 'authorized' do
            let(:me) { create :user }
            let(:access_token) { create :access_token, resource_owner_id: me.id }

            before { get "/api/v1/pets/#{pet.id}/comments/#{comment.id}", format: :json, access_token: access_token.token }

            it 'returns 200 status code' do
                expect(response).to be_success
            end

            it 'returns one pet' do
                expect(response.body).to have_json_size(1)
            end

            %w(id body created_at updated_at user_id pet_id).each do |attr|
                it "comment object contains #{attr}" do
                    expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comment/#{attr}")
                end
            end
        end

        def do_request(options = {})
            get "/api/v1/pets/#{pet.id}/comments/#{comment.id}", { format: :json }.merge(options)
        end
    end

    describe 'POST /create' do
        let(:pet) { create :pet }

        it_behaves_like 'API Authenticable'

        context 'authorized' do
            let(:me) { create :user }
            let(:access_token) { create :access_token, resource_owner_id: me.id }

            context 'with valid attributes' do
                it 'returns 200 status code' do
                    post "/api/v1/pets/#{pet.id}/comments", comment: attributes_for(:comment), format: :json, access_token: access_token.token

                    expect(response).to be_success
                end

                it 'saves the new pet in the DB and it belongs to current user' do
                    expect { post "/api/v1/pets/#{pet.id}/comments", comment: attributes_for(:comment), format: :json, access_token: access_token.token }.to change(me.comments, :count).by(1)
                end
            end

            context 'with invalid attributes' do
                it 'doesnt return 200 status code' do
                    post "/api/v1/pets/#{pet.id}/comments", comment: attributes_for(:comment, :invalid), format: :json, access_token: access_token.token

                    expect(response).to_not be_success
                end

                it 'doesnt save the new pet in the DB' do
                    expect { post "/api/v1/pets/#{pet.id}/comments", comment: attributes_for(:comment, :invalid), format: :json, access_token: access_token.token }.to_not change(Comment, :count)
                end
            end
        end

        def do_request(options = {})
            post "/api/v1/pets/#{pet.id}/comments", { format: :json }.merge(options)
        end
    end
end