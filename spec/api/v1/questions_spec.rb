require_relative '../api_helper'

describe 'Questions API' do
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET /index' do
    let (:uri) { "#{api_v1_questions_path}.json" }

    let(:api_authenticable) do
      { request_uri: uri, request_type: :get, options: {} }
    end
    it_behaves_like 'API authenticable'

    context 'when authorized' do
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question, user: question.user) }

      before { get uri, params: { access_token: access_token.token } }

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

    let(:api_authenticable) do
      { request_uri: uri, request_type: :get, options: {} }
    end
    it_behaves_like 'API authenticable'

    context 'when authorized' do
      before { get uri, params: { access_token: access_token.token } }

      it 'returns question object is identical to its schema' do
        expect(response.body).to match_json_schema('v1/questions/show')
      end
    end # context 'when authorized'
  end # describe 'GET /show'

  describe 'POST /create' do
    let(:uri) { "#{api_v1_questions_path}.json" }
    let(:params_without_token) do
      { question: attributes_for(:question) }
    end

    let(:api_authenticable) do
      { request_uri: uri, request_type: :get,
        options: { params: params_without_token } }
    end
    it_behaves_like 'API authenticable'

    describe 'when authorized' do
      let(:params) { params_without_token.merge(access_token: access_token.token) }

      context 'and params is valid' do
        it 'create new question' do
          expect {
            post uri, params: params
          }.to change(user.questions, :count).by(1)
        end

        %w(title body).each do |attr|
          it "created question have valid #{attr}" do
            post uri, params: params
            new_question_attr = user.questions.last.send(attr.to_sym)
            expect(params[:question][attr.to_sym]).to eq(new_question_attr)
          end
        end

        it 'returns question object is identical to its schema' do
          post uri, params: params
          expect(response.body).to match_json_schema('v1/questions/show')
        end
      end # context 'and params is valid'

      context 'and params is invalid' do
        let(:params) do
          { question: attributes_for(:invalid_question),
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
