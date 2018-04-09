require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user_with_questions, questions_count: 2) }
  let(:questions) { user.questions }

  describe 'GET #index' do
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to eq questions
    end

    it 'render index view' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    let(:question) { questions.last }
    before { get :show, params: { id: question } }

    it 'assign request question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render show view' do
      expect(response).to render_template(:show)
    end

    it 'assign new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
      expect(assigns(:answer).question_id).to eq question.id
    end
  end

  describe 'GET #new' do
    context 'with authorized user' do
      before do
        sign_in create(:user)
        get :new
      end

      it 'assign new Question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'render new view' do
        expect(response).to render_template(:new)
      end
    end

    context 'with unauthorized user' do
      it 'render sign in view' do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    before { sign_in user }

    context 'with valid parameters' do
      let(:params) do
        { question: attributes_for(:question) }
      end

      it 'save new question in database' do
        expect {
          post :create, params: params
        }.to change(Question, :count).by(1)
      end
    end

    context 'with invalid parameters' do
      let(:params) do
        { question: attributes_for(:invalid_question) }
      end

      it 'don\'t save new question in database' do
        expect {
          post :create, params: params
        }.to_not change(Question, :count)
      end

      it 'render new view' do
        post :create, params: params
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'DELETE #delete' do
    let(:first_user) { create(:user_with_question_and_answers, answers_count: 2) }
    let(:first_user_question) { first_user.questions.last }

    let(:second_user) { create(:user_with_question_and_answers) }
    let(:second_user_question) { second_user.questions.last }

    before { sign_in(first_user) }

    context 'author' do
      it 'delete question' do
        expect {
          delete :destroy, params: { id: first_user_question }
        }.to change(first_user.questions, :count).by(-1)
      end

      it 'delete answers of deleted question' do
        expect {
          delete :destroy, params: { id: first_user_question }
        }.to change(first_user_question.answers, :count).by(-2)
      end

      it 'redirect to questions' do
        delete :destroy, params: { id: first_user_question }
        expect(response).to redirect_to(questions_path)
      end
    end

    context 'not author' do
      it 'can\'t delete question' do
        expect {
          delete :destroy, params: { id: second_user_question }
        }.to_not change(second_user.questions, :count)
      end
      it 'render question show view' do
        delete :destroy, params: { id: second_user_question }
        expect(response).to render_template(:show)
      end
    end
  end
end
