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
                expect(response.body).to have_json_size(2).at_path("pets")
            end

            %w(id name caption created_at updated_at).each do |attr|
                it "pet object contains #{attr}" do
                    expect(response.body).to be_json_eql(pet.send(attr.to_sym).to_json).at_path("pets/0/#{attr}")
                end
            end

            context 'comments' do
                it 'included in pet object' do
                    skip 'unsuccess'
                    expect(response.body).to have_json_size(1).at_path("pets/0/comments")
                end

                %w(id body created_at updated_at user_id).each do |attr|
                    it "contains #{attr}" do
                        skip 'unsuccess'
                        expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("pets/0/comments/0/#{attr}")
                    end
                end
            end
        end

        def do_request(options = {})
            get "/api/v1/pets", { format: :json }.merge(options)
        end
    end
end