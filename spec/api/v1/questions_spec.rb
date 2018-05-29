require_relative '../api_helper'

describe 'Questions API' do
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET /index' do
    let (:uri) { "#{api_v1_questions_path}.json" }

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
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question, user: question.user) }

      before do
        get uri, params: { access_token: access_token.token }
      end

      it 'returns status 200' do
        expect(response).to be_successful
      end

      it 'returns questions object is identical to its schema' do
        expect(response.body).to match_json_schema('v1/questions/index')
      end
    end # context 'when authorized'
  end # describe 'GET /index'

  describe 'GET /show' do
    let!(:question) { create(:question, user: user) }
    let!(:comment) { create(:comment, commentable: question, user: user) }
    let!(:attachement) { create(:attachement, attachable: question) }

    let (:uri) { "#{api_v1_question_path(question)}.json" }

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
      before do
        get uri, params: { access_token: access_token.token }
      end

      it 'returns status 200' do
        expect(response).to be_successful
      end

      it 'returns question object is identical to its schema' do
        expect(response.body).to match_json_schema('v1/questions/show')
      end
    end # context 'when authorized'
  end
end
