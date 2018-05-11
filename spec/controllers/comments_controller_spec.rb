require 'rails_helper'
require 'with_model'

RSpec.describe CommentsController, type: :controller do

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

  let(:user) { create(:user) }
  let(:any_commentable) { AnyCommented.create(user: user) }

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
          expect(response.body).to match('{"status":true,"message":"Success"}')
        end
      end

      context 'when not author of comment' do
        before { sign_in(create(:user)) }

        it 'can\'t delete comment' do
          expect {
            delete :destroy, params
          }.to_not change(user.comments, :count)
        end

        it 'response body has error' do
          delete :destroy, params
          expect(response.body).to match('{"status":false,"errors":["You can not do it"]}')
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
