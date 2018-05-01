require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:params) do
      { question_id: question, vote: { value: true } }
    end

    context 'Authenticated user' do
      context 'when author of question' do
        before { sign_in(user) }

        it 'can\'t create vote' do
          expect {
            post :create, params: params, format: :js
          }.to_not change(user.votes, :count)
        end
      end

      context 'when not author of question' do
        let(:not_author) { create(:user) }
        before { sign_in(not_author) }

        it 'vote save in database and related with it question' do
          expect {
            post :create, params: params, format: :js
          }.to change(question.votes, :count).by(1)
        end

        it 'vote related with it user' do
          expect {
            post :create, params: params, format: :js
          }.to change(not_author.votes, :count).by(1)
        end
      end
    end

    context 'Unauthenticated user' do
      it 'can\'t create vote' do
        expect {
          post :create, params: params, format: :js
        }.to_not change(user.votes, :count)
      end
    end
  end
end
