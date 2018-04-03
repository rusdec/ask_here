require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to eq questions
    end

    it 'render index view' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }
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
    before { get :new }
    
    it 'assign new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:params) do
        { question: attributes_for(:question) }
      end

      it 'save new question in database' do
        expect {
          post :create, params: params
        }.to change(Question, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: params
        expect(response).to redirect_to question_path(assigns(:question))
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
end
