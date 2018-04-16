require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user_with_question_and_answers) }
  let(:question) { user.questions.last }
  let(:answer) { question.answers.last }

  describe 'POST #create' do
    before { sign_in(user) }

    context 'with valid parameters' do
      let(:params) do
        { question_id: question,
          answer: attributes_for(:answer) }
      end

      it 'save new answer in database' do
        expect {
          post :create, params: params, format: :js
        }.to change(question.answers, :count).by(1)
      end

      it 'new answer belong to his author' do
        expect {
          post :create, params: params, format: :js
        }.to change(user.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, params: params, format: :js
        expect(response).to render_template 'create'
      end
    end

    context 'with invalid parameters' do
      let(:params) do
        { question_id: question,
          answer: attributes_for(:invalid_answer) }
      end

      it 'don\'t save new answer in database' do
        expect {
          post :create, params: params, format: :js
        }.to_not change(question.answers, :count)
      end

      it 'render create template' do
        post :create, params: params, format: :js
        expect(response).to render_template 'create'
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:params) do
      { id: answer }
    end

    context 'author' do
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

    context 'not authenticated user' do
      it 'can\'t delete answer' do
        expect {
          delete :destroy, params: params, format: :js
        }.to_not change(question.answers, :count)
      end
    end

    context 'not author' do
      before { sign_in(create(:user)) }

      it 'can\'t delete answer' do
        expect {
          delete :destroy, params: params, format: :js
        }.to_not change(question.answers, :count)
      end
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user_with_question_and_answers) }
    let(:question) { user.questions.last }
    let(:answer) { question.answers.last }
    let(:new_body) { 'NewValidAnswerBody' }
    let(:params) do
      { id: answer, answer: { body: new_body } }
    end
    let(:another_user) { create(:user) }
    
    context 'when authenticated user is author' do
      before { sign_in(user) }

      it 'can update answer with valid data' do
        patch :update, params: params, format: :js
        answer.reload

        expect(answer.body).to eq(new_body)
      end

      it 'can\'t update answer with invalid data' do
        old_answer = answer
        params[:body] = nil
        patch :update, params: params, format: :js
        answer.reload

        expect(answer.body).to eq(old_answer.body)
      end

      it 'render update view' do
        patch :update, params: params, format: :js

        expect(response).to render_template(:update)
      end
    end

    context 'when authenticated user isn\'t author' do
      before { sign_in(another_user) }

      it 'can\'t update answer' do
        old_answer = answer
        patch :update, params: params, format: :js
        answer.reload

        expect(answer.body).to eq(old_answer.body)
      end

      it 'render update view' do
        patch :update, params: params, format: :js

        expect(response).to render_template(:update)
      end
    end

    context 'when unauthenticated user' do
      it 'can\'t update answer' do
        old_answer = answer
        patch :update, params: params, format: :js

        answer.reload

        expect(answer.body).to eq(old_answer.body)
      end
    end
  end
end
