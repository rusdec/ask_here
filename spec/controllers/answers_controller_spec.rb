require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user_with_question_and_answers) }
  let(:question) { user.questions.last }
  let(:answer) { question.answers.last }

  describe 'POST #create' do
    before { sign_in(user) }

    context 'with valid parameters' do
      let(:params) do
        { params: { question_id: question, answer: attributes_for(:answer) },
          format: :json }
      end

      it 'save new answer in database' do
        expect {
          post :create, params
        }.to change(question.answers, :count).by(1)
      end

      it 'new answer belong to his author' do
        expect {
          post :create, params
        }.to change(user.answers, :count).by(1)
      end

      it 'response body success' do
        post :create, params
        expect(response.body).to match('{"status":true,"message":"Success"}')
      end
    end

    context 'with invalid parameters' do
      let(:params) do
        { params: { question_id: question,
                    answer: attributes_for(:invalid_answer) },
          format: :json }
      end

      it 'don\'t save new answer in database' do
        expect {
          post :create, params
        }.to_not change(question.answers, :count)
      end

      it 'response body has error' do
        post :create, params
        expect(response.body).to match('{"status":false,"errors":["Body can\'t be blank","Body is too short (minimum is 10 characters)"]}')
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:params) do
      { id: answer }
    end

    context 'when author' do
      before { sign_in(user) }

      it 'delete answer' do
        expect { 
          delete :destroy, params: params, format: :js
        }.to change(question.answers, :count).by(-1)
      end

      it 'render question destroy view' do
        delete :destroy, params: params, format: :js
        expect(response).to render_template(:destroy)
      end
    end

    context 'when unauthenticated user' do
      it 'can\'t delete answer' do
        expect {
          delete :destroy, params: params, format: :js
        }.to_not change(question.answers, :count)
      end
    end

    context 'when not author' do
      before { sign_in(create(:user)) }

      it 'can\'t delete answer' do
        expect {
          delete :destroy, params: params, format: :js
        }.to_not change(question.answers, :count)
      end

      it 'redirect to root' do
        delete :destroy, params: params, format: :js
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user_with_question_and_answers) }
    let(:question) { user.questions.last }
    let(:answer) { question.answers.last }
    let(:new_body) { 'NewValidAnswerBody' }
    let(:params) do
      { params: { id: answer, answer: { body: new_body } },
        format: :json }
    end
    let(:another_user) { create(:user) }

    context 'when authenticated user is author' do
      before { sign_in(user) }

      it 'can update answer with valid data' do
        patch :update, params
        answer.reload

        expect(answer.body).to eq(new_body)
      end

      it 'can\'t update answer with invalid data' do
        old_answer = answer
        params[:params][:answer][:body] = nil
        patch :update, params
        answer.reload

        expect(answer.body).to eq(old_answer.body)
      end

      it 'response body success' do
        post :update, params

        expect(response.body).to match('{"status":true,"message":"Success"}')
      end
    end

    context 'when authenticated user isn\'t author' do
      before { sign_in(another_user) }

      it 'can\'t update answer' do
        old_answer = answer
        patch :update, params
        answer.reload

        expect(answer.body).to eq(old_answer.body)
      end

      it 'redirect to root' do
        post :update, params
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when unauthenticated user' do
      it 'can\'t update answer' do
        old_answer = answer
        patch :update, params

        answer.reload

        expect(answer.body).to eq(old_answer.body)
      end
    end
  end

  describe 'PATCH #best_answer' do

    let(:another_answer) { create(:answer, question: question, user: user) }
    let(:params) do
      { id: answer }
    end

    context 'when authenticated user is author of question' do
      before { sign_in(user) }

      it 'can set best answer' do
        expect(answer).to_not be_best

        patch :best_answer, params: params, format: :js
        answer.reload

        expect(answer).to be_best
      end

      it 'can set another best answer' do
        patch :best_answer, params: params, format: :js
        patch :best_answer, params: { id: another_answer }, format: :js

        answer.reload
        another_answer.reload
        
        expect(answer).to_not be_best
        expect(another_answer).to be_best
      end

      it 'render best_answer view' do
        patch :best_answer, params: params, format: :js

        expect(response).to render_template(:best_answer)
      end
    end

    context 'when authenticated user isn\'t author of question' do
      it 'can\'t set best answer' do
        sign_in(create(:user))

        expect(answer).to_not be_best
        patch :best_answer, params: params, format: :js

        answer.reload

        expect(answer).to_not be_best
      end
    end

    context 'when unauthenticated user' do
      it 'can\'t set best answer' do
        expect(answer).to_not be_best
        patch :best_answer, params: params, format: :js

        answer.reload

        expect(answer).to_not be_best
      end
    end
  end

  describe 'PATCH #not_best_answer' do
    let!(:best_answer) { create(:best_answer, user: user, question: question) }
    let(:params) do
      { id: best_answer }
    end

    context 'when authenticated user is author of question' do
      before { sign_in(user) }

      it 'can unset best answer' do
        expect(best_answer).to be_best

        patch :not_best_answer, params: params, format: :js
        best_answer.reload

        expect(best_answer).to_not be_best
      end

      it 'render not_best_answer view' do
        patch :not_best_answer, params: params, format: :js

        expect(response).to render_template(:not_best_answer)
      end
    end

    context 'when authenticated user isn\'t author of question' do
      it 'can\'t unset best answer' do
        sign_in(create(:user))

        expect(best_answer).to be_best
        patch :not_best_answer, params: params, format: :js

        best_answer.reload

        expect(best_answer).to be_best
      end
    end

    context 'when unauthenticated user' do
      it 'can\'t unset best answer' do
        expect(best_answer).to be_best
        patch :not_best_answer, params: params, format: :js

        answer.reload

        expect(best_answer).to be_best
      end
    end
  end
end
