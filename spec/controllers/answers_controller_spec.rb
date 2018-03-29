require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:answers) { create_list(:answer, 2, question: question) }
    before { get :index, params: { question_id: question } }

    it 'populates an array of all answer for certain question' do
      expect(assigns(:answers)).to eq(answers)
    end

    it 'render index view' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'assign new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'question in assigned @answer must exist' do
      expect(assigns(:answer).question_id).to eq(question.id)
    end

    it 'render new view' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:params) do
        { question_id: question,
          answer: attributes_for(:answer) }
      end

      it 'save new answer in database' do
        expect {
          post :create, params: params
        }.to change(Answer, :count).by(1)
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

      it 'render new view' do
        post :create, params: params
        expect(response).to render_template(:new)
      end
    end
  end
end
