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
          post :vote, to: 'any_voteds#create_vote'
          patch :vote, to: 'any_voteds#update_vote'
          delete :vote, to: 'any_voteds#destroy_vote'
        end
      end

      resources :any_voteds do
        concerns :votable
      end
    end
  end

  let(:user) { create(:user) }
  let(:any_votable) { AnyVoted.create(user: user) }

  describe 'POST #create_vote' do
    let(:params) do
      { id: any_votable, vote: { value: true } }
    end

    context 'Authenticated user' do
      context 'when author of any_votable' do
        before { sign_in(user) }
        it 'can\'t create vote' do
          expect {
            post :create_vote, params: params, format: :json
          }.to_not change(Vote, :count)
        end

        it 'response body has error' do
          post :create_vote, params: params, format: :json
          expect(response.body).to match('{"status":false,"errors":["You can not vote for it"]}')
        end
      end

      context 'when not author of any votable' do
        let(:not_author) { create(:user) }
        before { sign_in(not_author) }

        it 'vote save in database and related with it any votable' do
          expect {
            post :create_vote, params: params, format: :json
          }.to change(any_votable.votes, :count).by(1)
        end

        it 'vote related with it user' do
          expect {
            post :create_vote, params: params, format: :json
          }.to change(not_author.votes, :count).by(1)
        end

        it 'response body has success' do
          post :create_vote, params: params, format: :json
          expect(response.body).to match('{"status":true,"message":"Vote create success","votes":{"likes":1,"dislikes":0,"rate":1}}')
        end
      end
    end

    context 'Unauthenticated user' do
      it 'can\'t create vote' do
        expect {
          post :create_vote, params: params, format: :json
        }.to_not change(user.votes, :count)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:vote) { create(:vote, user: user, votable: any_votable, value: false) }
    let(:params) do
      { id: any_votable, vote: { value: true } }
    end

    context 'Authenticated user' do
      context 'when author of vote' do
        before { sign_in(user) }

        it 'can update value' do
          expect(vote).to_not be_value

          patch :update_vote, params: params, format: :json
          vote.reload

          expect(vote).to be_value
        end

        it 'response body has success' do
          patch :update_vote, params: params, format: :json
          expect(response.body).to match('{"status":true,"message":"Vote update success","votes":{"likes":1,"dislikes":0,"rate":1}}')
        end
      end

      context 'when not author of vote' do
        let(:not_author) { create(:user) }
        before { sign_in(not_author) }

        it 'can\'t update value' do
          expect(vote).to_not be_value

          patch :update_vote, params: params, format: :json
          vote.reload

          expect(vote).to_not be_value
        end

        it 'response body has error' do
          patch :update_vote, params: params, format: :json
          expect(response.body).to match('{"status":false,"errors":["You can not vote for it"]}')
        end
      end
    end

    context 'Unauthenticated user' do
      it 'can\'t update value' do
        expect(vote).to_not be_value

        patch :update_vote, params: params, format: :json
        vote.reload

        expect(vote).to_not be_value
      end
    end
  end

  describe 'DELETE #destroy' do
    before { create(:vote, user: user, votable: any_votable, value: false) }
    let(:params) { { id: any_votable } }

    context 'Authenticated user' do
      context 'when author of vote' do
        before { sign_in(user) }

        it 'can delete vote' do
          expect {
            delete :destroy_vote, params: params, format: :json
          }.to change(user.votes, :count).by(-1)
        end

        it 'response body has success' do
          delete :destroy_vote, params: params, format: :json
          expect(response.body).to match('{"status":true,"message":"Vote delete success","votes":{"likes":0,"dislikes":0,"rate":0}}')
        end
      end

      context 'when not author of vote' do
        before { sign_in(create(:user)) }

        it 'can\'t delete vote' do
          expect {
            delete :destroy_vote, params: params, format: :json
          }.to_not change(user.votes, :count)
        end

        it 'response body has error' do
          delete :destroy_vote, params: params, format: :json
          expect(response.body).to match('{"status":false,"errors":["You can not vote for it"]}')
        end
      end
    end

    context 'Unauthenticated user' do
      it 'can\'t delete vote' do
        expect {
          delete :destroy_vote, params: params, format: :json
        }.to_not change(user.votes, :count)
      end
    end
  end
end
