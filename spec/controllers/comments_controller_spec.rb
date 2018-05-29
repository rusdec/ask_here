require_relative 'controllers_helper'
require 'with_model'

RSpec.describe CommentsController, type: :controller do

  controller CommentsController do
  end

  with_model :AnyCommentable do
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
      concern :commentable do
        resources :comments, only: %i[destroy update create], shallow: true
      end

      resource :any_commenteds do
        concerns :commentable
      end
    end
  end

  let(:user) { create(:user) }
  let(:any_commentable) { AnyCommentable.create(user: user) }

  describe 'POST #create' do
    let(:params) do
      { params: { 
          any_commentable_id: any_commentable,
          comment: attributes_for(:comment) },
        format: :json }
    end

    context 'Authenticated user' do
      context 'when author of any_commentable' do
        before { sign_in(user) }

        it 'comment save in database and related with it any commentable' do
          expect {
            post :create, params
          }.to change(any_commentable.comments, :count).by(1)
        end

        it 'comment related with it user' do
          expect {
            post :create, params
          }.to change(user.comments, :count).by(1)
        end

        it 'response body has success' do
          post :create, params
          expect(response.body).to eq(json_success_hash.to_json)
        end
      end

      context 'when not author of any commentable' do
        let(:not_author) { create(:user) }
        before { sign_in(not_author) }

        it 'comment save in database and related with it any commentable' do
          expect {
            post :create, params
          }.to change(any_commentable.comments, :count).by(1)
        end

        it 'comment related with it user' do
          expect {
            post :create, params
          }.to change(not_author.comments, :count).by(1)
        end
      end
    end

    context 'Unauthenticated user' do
      it 'can\'t create comment' do
        expect {
          post :create, params
        }.to_not change(any_commentable.comments, :count)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:comment) { create(:comment, user: user, commentable: any_commentable) }
    let(:new_body) { 'NewValidCommentBodyText' }
    let(:params) do
      { params: {  id: comment, comment: { body: new_body } },
        format: :json }
    end

    context 'Authenticated user' do
      context 'when author of comment' do
        before { sign_in(user) }

        it 'update comment with new data' do
          patch :update, params
          comment.reload

          expect(comment.body).to eq(new_body)
        end

        it 'response body has success' do
          patch :update, params
          expect(response.body).to eq(json_success_hash.to_json)
        end
      end

      context 'when not author of comment' do
        before { sign_in(create(:user)) }

        it 'can\'t update comment' do
          old_body = comment.body
          patch :update, params
          comment.reload

          expect(comment.body).to eq(old_body)
        end

        context 'and format' do
          context 'html' do
            it 'redirect to root' do
              params[:format] = :html
              patch :update, params
              expect(response).to redirect_to(root_path)
            end
          end

          context 'json' do
            it 'return error hash' do
              params[:format] = :json
              patch :update, params
              expect(response.body).to eq(json_access_denied_hash.to_json)
            end
          end
        end
      end
    end

    context 'Unauthenticated user' do
      it 'can\'t update comment' do
        old_body = comment.body
        patch :update, params
        comment.reload

        expect(comment.body).to eq(old_body)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:comment) { create(:comment, user: user, commentable: any_commentable) }
    let(:params) do
      { params: { id: comment }, format: :json }
    end

    context 'Authenticated user' do
      context 'when author of comment' do
        before { sign_in(user) }

        it 'can delete comment' do
          expect {
            delete :destroy, params
          }.to change(user.comments, :count).by(-1)
        end

        it 'response body has success' do
          delete :destroy, params
          expect(response.body).to eq(json_success_hash.to_json)
        end
      end

      context 'when not author of comment' do
        before { sign_in(create(:user)) }

        it 'can\'t delete comment' do
          expect {
            delete :destroy, params
          }.to_not change(user.comments, :count)
        end

        context 'and format' do
          context 'html' do
            it 'redirect to root' do
              params[:format] = :html
              delete :destroy, params
              expect(response).to redirect_to(root_path)
            end
          end

          context 'json' do
            it 'return error hash' do
              params[:format] = :json
              delete :destroy, params
              expect(response.body).to eq(json_access_denied_hash.to_json)
            end
          end
        end
      end
    end

    context 'Unauthenticated user' do
      it 'can\'t delete comment' do
        expect {
          delete :destroy, params
        }.to_not change(any_commentable.comments, :count)
      end
    end
  end
end
