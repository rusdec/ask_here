require_relative '../api_helper'

describe 'Answers API' do
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET /index' do
    let!(:question) { create(:question, user: user) }
    let (:uri) { "#{api_v1_question_answers_path(question)}.json" }

    let(:api_authenticable) do
      { request_type: :get, request_uri: uri, options: {} }
    end
    it_behaves_like 'API authenticable'

    context 'when authorized' do
      let!(:answers) { create_list(:answer, 2, question: question, user: user) }

      before { get uri, params: { access_token: access_token.token } }

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

    let(:api_authenticable) do
      { request_type: :get, request_uri: uri, options: {} }
    end
    it_behaves_like 'API authenticable'

    context 'when authorized' do
      before { get uri, params: { access_token: access_token.token } }

      it 'returns answers object is identical to its schema' do
        expect(response.body).to match_json_schema('v1/answers/show')
      end
    end # context 'when authorized'
  end # describe 'GET /show'

  describe 'POST /create' do
    let!(:question) { create(:question, user: user) }
    let(:uri) { "#{api_v1_question_answers_path(question)}.json" }
    let(:params_without_token) do
      { question: question, answer: attributes_for(:answer) }
    end
    
    let(:api_authenticable) do
      { request_type: :post, request_uri: uri,
        options: { params: params_without_token } }
    end
    it_behaves_like 'API authenticable'

    context 'when unauthorized' do
      context 'and isn\'t access_token ' do
        it 'returns status 401' do
          post uri, params: params_without_token
          expect(response.status).to eq(401)
        end
      end

      context 'and access_token is invalid' do
        it 'returns status 401' do
          post uri, params: params_without_token.merge(access_token: 'bad_token')
          expect(response.status).to eq(401)
        end
      end
    end # context 'when unauthorized'

    describe 'when authorized' do
      let(:params) { params_without_token.merge(access_token: access_token.token) }

      context 'and params is valid' do
        it 'create new answer' do
          expect {
            post uri, params: params
          }.to change(question.answers, :count).by(1)
        end

        it 'new answer related with user' do
          expect {
            post uri, params: params
          }.to change(user.answers, :count).by(1)
        end

        it 'created answer have valid body' do
          post uri, params: params
          expect(params[:answer][:body]).to eq(question.answers.last.body)
        end

        it 'returns answer object is identical to its schema' do
          post uri, params: params
          expect(response.body).to match_json_schema('v1/answers/show')
        end
      end # context 'and params is valid'

      context 'and params is invalid' do
        let(:params) do
          { question: question,
            answer: attributes_for(:invalid_answer),
            access_token: access_token.token }
        end

        it 'returns object contains errors' do
          post uri, params: params
          expect(response.body).to have_json_path('errors')
        end
      end # context 'and params is invalid'
    end
  end # describe 'POST /create'
end
