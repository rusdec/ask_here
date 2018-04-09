require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user_with_question_and_answers) }
  let(:question) { user.questions.last }
  let(:answer) { question.answers.last }

  describe 'GET #index' do
    before { get :index, params: { question_id: question } }

    it 'populates an array of all answer for certain question' do
      expect(assigns(:answers)).to eq(question.answers)
    end

    it 'render index view' do
      expect(response).to render_template(:index)
    end
  end

  describe 'POST #create' do
    before { sign_in(user) }

    context 'with valid parameters' do
      let(:params) do
        { question_id: question,
          answer: attributes_for(:answer) }
      end

      it 'save new answer in database' do
        expect {
          post :create, params: params
        }.to change(question.answers, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: params
        expect(response).to redirect_to question_path(assigns(:question))
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
        }.to_not change(Answer, :count)
      end

      it 'render question show view' do
        post :create, params: params
        expect(response).to render_template('questions/show')
      end
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in(user) }

    context 'author' do
      it 'delete answer' do
        expect { 
          delete :destroy, params: { id: answer }
        }.to change(question.answers, :count).by(-1)
      end

      it 'render question show view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'not author' do
      it 'can\'t delete answer' do
        expect {
          delete :destroy, params: { id: answer }
        }.to change(question.answers, :count)
      end

      it 'redirect to question show view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
