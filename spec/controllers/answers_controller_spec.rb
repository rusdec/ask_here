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
          post :create, params: params
        }.to_not change(question.answers, :count)
      end

      it 'render question show view' do
        post :create, params: params
        expect(response).to render_template('questions/show')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'author' do
      before { sign_in(user) }
      it 'delete answer' do
        expect { 
          delete :destroy, params: { id: answer }
        }.to change(question.answers, :count).by(-1)
      end

      it 'render question show view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question
      end
    end

    context 'not authenticated user' do
      it 'can\'t delete answer' do
        expect {
          delete :destroy, params: { id: answer }
        }.to_not change(question.answers, :count)
      end

      it 'redirect to sign in view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'not author' do
      before { sign_in(create(:user)) }

      it 'can\'t delete answer' do
        expect {
          delete :destroy, params: { id: answer }
        }.to_not change(question.answers, :count)
      end

      it 'redirect to question show view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question
      end
    end
  end
end
