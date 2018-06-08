require_relative 'controllers_helper'
require 'with_model'

RSpec.describe SubscriptionsController, type: :controller do

  controller SubscriptionsController do
  end

  with_model :any_subscribable do
    table do |t|
      t.integer :user_id
    end

    model do
      include Userable
    end
  end

  before do
    routes.draw do
      concern :subscribable do
        resources :subscriptions, only: %i[create destroy], shallow: true
      end
      
      resources :any_subscribables do
        concerns :subscribable
      end
    end
  end

  let!(:user) { create(:user) }
  let!(:any_subscribable) { AnySubscribable.create(user: user) }
  let(:format) { :json }

  describe 'POST #create' do
    context 'Authenticated user' do
      before { sign_in(user) }
      let(:params) { { any_subscribable_id: any_subscribable } }

      it 'save subscription in database' do
        expect {
          post :create, params: params, format: :json
        }.to change(user.subscriptions, :count).by(1)
      end

      it 'saved subscription relatesd with it question' do
        post :create, params: params, format: format
        expect(user.subscriptions.last.subscribable).to eq(any_subscribable)
      end

      it 'return successful' do
        post :create, params: params, format: format
        expect(response.body).to match_json_schema('subscriptions/create')
      end
    end

    context 'Unauthenticated user' do
      let(:params) { { any_subscribable_id: any_subscribable } }

      it 'can\'t create subscription' do
        expect {
            post :create, params: params, format: format
        }.to_not change(user.subscriptions, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) do
      create(:subscription, subscribable: any_subscribable, user: user)
    end
    let(:params) { { id: subscription } }

    context 'Authenticated user' do
      before { sign_in(user) }

      it 'delete subscription' do
        expect {
          delete :destroy, params: params, format: :json
        }.to change(user.subscriptions, :count).by(-1)
      end

      it 'return successfull' do
        delete :destroy, params: params, format: format
        expect(response.body).to match_json_schema('subscriptions/destroy')
      end
    end

    context 'Unauthenticated user' do
      it 'can\'t delete subscription' do
        expect {
            delete :destroy, params: params, format: format
        }.to_not change(user.subscriptions, :count)
      end
    end
  end
end
