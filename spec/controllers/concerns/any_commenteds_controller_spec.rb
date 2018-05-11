require 'rails_helper'
require 'with_model'

class AnyCommentedsController < ApplicationController; end

RSpec.describe AnyCommentedsController, type: :controller do

  controller do
    before_action :authenticate_user!
    include Commented
  end

  with_model :AnyCommented do
    table do |t|
      t.string :text, default: ''
      t.integer :user_id
    end

    model do
      include Commentable
      belongs_to :user
    end
  end

  before do
    routes.draw do
      concern :commentable do |options|
        post :comments, to: "#{options[:controller]}#create_comment"
      end

      resources :any_commenteds do
        concerns :commentable, controller: :any_commenteds
      end
    end
  end

  let(:user) { create(:user) }
  let(:any_commentable) { AnyCommented.create(user: user) }

  describe 'POST #create_comment' do
    let(:params) do
      { params: { any_commented_id: any_commentable, comment: attributes_for(:comment) },
        format: :json }
    end

    context 'Authenticated user' do
      context 'when author of any_commentable' do
        before { sign_in(user) }

        it 'comment save in database and related with it any commentable' do
          expect {
            post :create_comment, params
          }.to change(any_commentable.comments, :count).by(1)
        end

        it 'comment related with it user' do
          expect {
            post :create_comment, params
          }.to change(user.comments, :count).by(1)
        end

        it 'response body has success' do
          post :create_comment, params
          expect(response.body).to match('{"status":true,"message":"Success"}')
        end
      end

      context 'when not author of any commentable' do
        let(:not_author) { create(:user) }
        before { sign_in(not_author) }

        it 'comment save in database and related with it any commentable' do
          expect {
            post :create_comment, params
          }.to change(any_commentable.comments, :count).by(1)
        end

        it 'comment related with it user' do
          expect {
            post :create_comment, params
          }.to change(not_author.comments, :count).by(1)
        end
      end
    end

    context 'Unauthenticated user' do
      it 'can\'t create comment' do
        expect {
          post :create_comment, params
        }.to_not change(any_commentable.comments, :count)
      end
    end
  end
end
