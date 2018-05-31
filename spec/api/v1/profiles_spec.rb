require_relative '../api_helper'

describe 'Profile API' do
  describe 'GET /me' do
    let(:uri) { "#{me_api_v1_profiles_path}.json" }

    let(:api_authenticable) do
      { request_type: :get, request_uri: uri, options: {} }
    end
    it_behaves_like 'API authenticable'

    context 'when authentiacted' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get uri, params: { access_token: access_token.token } }

      it 'returns object profile is identical to its schema' do
        expect(response.body).to match_json_schema('v1/users/show')
      end

      %w(password encrypted_password).each do |name|
        it "not contains #{name}" do
          expect(response.body).to_not have_json_path(name)
        end
      end
    end # context 'when authorized'
  end # describe 'GET /me'

  describe 'GET /all' do
    let(:uri) { "#{api_v1_profiles_path}.json" }

    let(:api_authenticable) do
      { request_type: :get, request_uri: uri, options: {} }
    end
    it_behaves_like 'API authenticable'

    context 'when authenticated' do
      let(:me) { create(:user) }
      let!(:users) { create_list(:user, 2) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get uri, params: { access_token: access_token.token } }

      it "returns users object is identical to its schema" do
        expect(response.body).to match_json_schema('v1/users/index')
      end

      it 'not contains authenticated user' do
        expect(response.body).to_not include_json(me.to_json)
      end
    end # context 'when authorized'
  end # context 'GET /all'
end
