require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    let(:uri_me) { "#{me_api_v1_profiles_path}.json" }

    context 'when unauthorized' do
      context 'and isn\'t access_token ' do
        it 'returns status 401' do
          get uri_me
          expect(response.status).to eq(401)
        end
      end

      context 'and access_token is invalid' do
        it 'returns status 401' do
          get uri_me, params: { access_token: 'invalid_token' }
          expect(response.status).to eq(401)
        end
      end
    end # context 'when unauthorized'

    context 'when authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get uri_me, params: { access_token: access_token.token }
      end

      it 'returns status 200' do
        expect(response).to be_successful
      end

      %w(id email admin created_at updated_at).each do |name|
        it "contains #{name}" do
          expect(response.body).to be_json_eql(me.send(name.to_sym).to_json).at_path(name)
        end
      end

      %w(password encrypted_password).each do |name|
        it "not contains #{name}" do
          expect(response.body).to_not have_json_path(name)
        end
      end
    end # context 'when authorized'
  end # describe 'GET /me'

  describe 'GET /all' do
    let(:uri_all) { "#{api_v1_profiles_path}.json" }

    context 'when unauthorized' do
      context 'and isn\'t access_token ' do
        it 'returns status 401' do
          get uri_all
          expect(response.status).to eq(401)
        end
      end

      context 'and access_token is invalid' do
        it 'returns status 401' do
          get uri_all, params: { access_token: 'invalid_token' }
          expect(response.status).to eq(401)
        end
      end
    end # context 'when unauthorized'

    context 'when authorized' do
      let(:me) { create(:user) }
      let!(:users) { create_list(:user, 2) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get uri_all, params: { access_token: access_token.token }
      end

      it 'returns status 200' do
        expect(response).to be_successful
      end

      it "contains users" do
        users.each do |user|
          expect(response.body).to include_json(user.to_json)
        end
      end

      it 'not contains authenticated user' do
        expect(response.body).to_not include_json(me.to_json)
      end
    end # context 'when authorized'
  end # context 'GET /all'
end
