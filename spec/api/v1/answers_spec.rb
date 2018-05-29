require_relative '../api_helper'

describe 'Answers API' do
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET /index' do
    let!(:question) { create(:question, user: user) }
    let (:uri) { "#{api_v1_question_answers_path(question)}.json" }

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
      let!(:answers) { create_list(:answer, 2, question: question, user: user) }

      before do
        get uri, params: { access_token: access_token.token }
      end

      it 'returns status 200' do
        expect(response).to be_successful
      end

      it 'returns answers object is identical to its schema' do
        expect(response.body).to match_json_schema('v1/answers/index')
      end
    end # context 'when authorized'
  end # describe 'GET /index'

  describe 'GET /show' do
    let!(:answer) do
      create(:answer, question: create(:question, user: user), user: user)
    end
    let!(:comment) { create(:comment, commentable: answer, user: user) }
    let!(:attachement) { create(:attachement, attachable: answer) }

    let(:uri) { "#{api_v1_answer_path(answer)}.json" }

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

      it 'returns answers object is identical to its schema' do
        expect(response.body).to match_json_schema('v1/answers/show')
      end
    end # context 'when authorized'
  end
end
