require 'rails_helper'
require 'with_model'

class AnyVotedsController < ApplicationController; end

RSpec.describe AnyVotedsController, type: :controller do

  controller do
    before_action :authenticate_user!
    include Voted
  end

  with_model :AnyVoted do
    table do |t|
      t.string :text, default: ''
      t.integer :user_id
    end

    model do
      include Votable
      belongs_to :user
    end
  end

  before do
    routes.draw do
      concern :votable do
        member do
          post :vote, to: 'any_voteds#add_vote'
          delete :vote, to: 'any_voteds#cancel_vote'
        end
      end

      resources :any_voteds do
        concerns :votable
      end
    end
  end

  let(:user) { create(:user) }
  let(:any_votable) { AnyVoted.create(user: user) }

  describe 'POST #add_vote' do
    let(:params) do
      { id: any_votable, vote: { value: 1 } }
    end

    context 'Authenticated user' do
      context 'when author of any_votable' do
        before { sign_in(user) }
        it 'can\'t create vote' do
          expect {
            post :add_vote, params: params, format: :json
          }.to_not change(Vote, :count)
        end

        it 'redirect to root' do
          post :add_vote, params: params, format: :json
          expect(response).to redirect_to(root_path)
        end
      end

      context 'when not author of any votable' do
        let(:not_author) { create(:user) }
        before { sign_in(not_author) }

        it 'vote save in database and related with it any votable' do
          expect {
            post :add_vote, params: params, format: :json
          }.to change(any_votable.votes, :count).by(1)
        end

        it 'vote related with it user' do
          expect {
            post :add_vote, params: params, format: :json
          }.to change(not_author.votes, :count).by(1)
        end

        context 'and revote' do
          before { create(:vote, votable: any_votable, user: not_author, value: 1) }
          let(:dislike_params) { params.merge(vote: { value: -1 }) }

          it 'old vote delete' do
            expect {
              post :add_vote, params: dislike_params, format: :json
            }.to change(not_author.votes.where(value: 1), :count).by(-1)
          end

          it 'new vote save' do
            expect {
              post :add_vote, params: dislike_params, format: :json
            }.to change(not_author.votes.where(value: -1), :count).by(1)
          end
        end

        it 'response body has success' do
          post :add_vote, params: params, format: :json
          expect(response.body).to match('{"status":true,"message":"Success","votes":{"likes":1,"dislikes":0,"rate":1}}')
        end
      end
    end

    context 'Unauthenticated user' do
      it 'can\'t create vote' do
        expect {
          post :add_vote, params: params, format: :json
        }.to_not change(user.votes, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { create(:vote, user: user, votable: any_votable, value: -1) }
    let(:params) { { id: any_votable } }

    context 'Authenticated user' do
      context 'when author of vote' do
        before { sign_in(user) }

        it 'can delete vote' do
          expect {
            delete :cancel_vote, params: params, format: :json
          }.to change(user.votes, :count).by(-1)
        end

        it 'response body has success' do
          delete :cancel_vote, params: params, format: :json
          expect(response.body).to match('{"status":true,"message":"Success","votes":{"likes":0,"dislikes":0,"rate":0}}')
        end
      end

      context 'when not author of vote' do
        before { sign_in(create(:user)) }

        it 'can\'t delete vote' do
          expect {
            delete :cancel_vote, params: params, format: :json
          }.to_not change(user.votes, :count)
        end

        it 'redirect to root' do
          delete :cancel_vote, params: params, format: :json
          expect(response).to redirect_to(root_path)
        end
      end
    end

    context 'Unauthenticated user' do
      it 'can\'t delete vote' do
        expect {
          delete :cancel_vote, params: params, format: :json
        }.to_not change(user.votes, :count)
      end
    end
  end
end
