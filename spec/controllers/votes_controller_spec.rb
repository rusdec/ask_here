require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
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

  describe 'PATCH #update' do
    let!(:vote) { create(:question_vote,
                         user: user,
                         votable: question,
                         value: false) }
    let(:params) do
      { id: vote, vote: { value: true } }
    end
    
    context 'Authenticated user' do
      context 'when author of vote' do
        before { sign_in(user) }

        it 'can update value' do
          expect(vote).to_not be_value

          patch :update, params: params, format: :js
          vote.reload

          expect(vote).to be_value
        end
      end

      context 'when not author of vote' do
        before { sign_in(create(:user)) }

        it 'can\'t update value' do
          expect(vote).to_not be_value

          patch :update, params: params, format: :js
          vote.reload

          expect(vote).to_not be_value
        end
      end
    end

    context 'Unauthenticated user' do
      it 'can\'t update value' do
        expect(vote).to_not be_value

        patch :update, params: params, format: :js
        vote.reload

        expect(vote).to_not be_value
      end
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in(user) }

    context 'Authenticated user' do
      context 'when author of vote' do
      end

      context 'when not author of vote' do
        let(:not_author) { create(:user) }
        before { sign_in(not_author) }
      end
    end

    context 'Unauthenticated user' do
    end
  end
end
