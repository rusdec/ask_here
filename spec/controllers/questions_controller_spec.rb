require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:questions) { create_list(:question, 2, user: user) }
  let(:question) { questions.last }

  describe 'GET #index' do
    before { get :index }

    it 'populates an array of all questions' do
      puts questions.inspect
      puts assigns(:questions).inspect
      expect(assigns(:questions)).to eq questions
    end

    it 'render index view' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
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
    context 'when authenticated user' do
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

    context 'when unauthenticated user' do
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
        }.to change(user.questions, :count).by(1)
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

    context 'when authenticated user is author' do
      before { sign_in(first_user) }

      it 'delete question' do
        expect {
          delete :destroy, params: { id: first_user_question }, format: :js
        }.to change(first_user.questions, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: first_user_question }, format: :js
        expect(response).to render_template(:destroy)
      end
    end

    context 'when unauthenticated user' do
      it 'can\'t delete question' do
        expect {
          delete :destroy, params: { id: second_user_question }, format: :js
        }.to_not change(second_user.questions, :count)
      end
    end

    context 'when authenticated is not author' do
      before { sign_in(first_user) }

      it 'can\'t delete question' do
        expect {
          delete :destroy, params: { id: second_user_question }, format: :js
        }.to_not change(second_user.questions, :count)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: second_user_question }, format: :js
        expect(response).to render_template(:destroy)
      end
    end
  end

  describe 'PATCH #update' do
    let(:new_title) { 'NewQuestionValidTitle' }
    let(:new_body)  { 'NewQuestionValidBody' }
    let(:params) do
      { id: question, question: { title: new_title, body: new_body } }
    end

    context 'when authenticated user is author' do
      before { sign_in(user) }

      it 'can update question with valid parameters' do
        patch :update, params: params, format: :js

        question.reload

        expect(question.title).to eq(new_title)
        expect(question.body).to eq(new_body)
      end

      it 'render question update' do
        patch :update, params: params, format: :js
        
        expect(response).to render_template(:update)
      end

      it 'can\'t update question with invalid parameters' do
        old_question = question
        params[:question][:title] = nil
        params[:question][:body] = nil

        patch :update, params: params, format: :js

        question.reload

        expect(question.title).to eq(old_question.title)
        expect(question.body).to eq(old_question.body)
      end

    end

    context 'when authenticated user is not author' do
      let!(:old_question) { question }

      before do
        sign_in(create(:user))
        patch :update, params: params, format: :js
      end

      it 'can\'t update question' do
        question.reload

        expect(question.title).to eq(old_question.title)
        expect(question.body).to eq(old_question.body)
      end

      it 'render question update' do
        expect(response).to render_template(:update)
      end
    end

    context 'when unauthenticated user' do
      let!(:old_question) { question }

      it 'can\'t update question' do
        patch :update, params: params, format: :js

        question.reload

        expect(question.title).to eq(old_question.title)
        expect(question.body).to eq(old_question.body)
      end
    end
  end
end
