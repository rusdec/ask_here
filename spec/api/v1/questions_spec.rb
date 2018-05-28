require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    let (:uri) { '/api/v1/questions.json' }

    context 'when unauthorized' do
      context 'and isn\'t access_token ' do
        it 'returns status 401' do
          get uri
          expect(response.status).to eq(401)
        end
      end

      context 'and access_token is invalid' do
        it 'returns status 401' do
          get uri, params: { access_token: 'invalid_token' }
          expect(response.status).to eq(401)
        end
      end
    end # context 'when unauthorized'

    context 'when authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question, user: question.user) }

      before do
        get uri, params: { access_token: access_token.token }
      end

      it 'returns status 200' do
        expect(response).to be_successful
      end

      it 'returns two questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(
            question.send(attr.to_sym).to_json
          ).at_path("questions/0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json)
          .at_path('questions/0/short_title')
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        %w(id body created_at updated_at).each do |attr|
          it "question object contains #{attr}" do
            expect(response.body).to be_json_eql(
              answer.send(attr.to_sym).to_json
            ).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end # context 'when authorized'

  end
end
