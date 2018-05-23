require 'rails_helper'

#class AnyOauthSignedsController < ApplicationController; end
class AnyOauthSignedsController < Devise::OmniauthCallbacksController; end

RSpec.describe AnyOauthSignedsController, type: :controller do
  controller AnyOauthSignedsController do
    include OauthSigned

    def sign_in_flow_test
      auth = { uid: params[:uid], provider: params[:provider], info: {} }

      auth[:info][:email] = params[:email] if params[:email]
      auth[:with_request_email] = true if params[:with_request_email]

      request.env['omniauth.auth'] = OmniAuth::AuthHash.new(auth)

      sign_in_flow
    end

    def try_to_sign_in_test
      request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
        uid: params[:uid],
        provider: params[:provider],
        info: { email: params[:email] }
      )

      try_to_sign_in
    end
  end

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]

    routes.draw do
      get :sign_in_flow_test, to: 'any_oauth_signeds#sign_in_flow_test'
      get :try_to_sign_in_test, to: 'any_oauth_signeds#try_to_sign_in_test'
      post :authorization_after_request_email,
           to: 'any_oauth_signeds#authorization_after_request_email'
    end
  end

  let(:params) do
    { uid: 'any_uid', provider: 'any_provider' }
  end
  let(:params_with_email) { params.merge(email: 'example@email.com') }

  describe 'POST #authorization_after_request_email' do
    before do
      post :authorization_after_request_email,
           params: params_with_email
    end

    it 'redirect to sign in' do
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'set flash message' do
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unconfirmed'))
    end
  end

  describe 'GET #try_to_sign_in_test' do
    context 'when email valid' do
      before do
        get :try_to_sign_in_test, params: params_with_email
      end

      it 'redirect to root' do
        expect(response).to redirect_to(root_path)
      end

      it 'set flash message' do
        expect(
          flash[:notice]
        ).to eq('Successfully authenticated from Any_provider account.')
      end
    end

    context 'when email invalid' do
      before do
        get :try_to_sign_in_test, params: params.merge!(email: '')
      end

      it 'redirect to sign in' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'set flash message' do
        expect(flash[:alerts]).to_not be_empty
      end
    end
  end

  describe 'GET #sign_in_flow_test' do
    let(:email) { 'example@email.com' }

    context 'when auth email exist' do
      before do
        get :sign_in_flow_test, params: params.merge!(email: email)
      end

      it 'redirect to root' do
        expect(response).to redirect_to(root_path)
      end

      it 'set flash message' do
        expect(flash[:notice]).to eq('Successfully authenticated from Any_provider account.')
      end
    end

    context 'when auth email not exist' do
      context 'find authorization by uid and provider' do
        let(:auth_params) do
          { uid: params[:uid], provider: params[:provider] }
        end

        context 'when authorization exist and user is confirmed' do;
          before do
            auth_params[:user] = create(:user, email: email, confirmed_at: Time.now)
            create(:authorization, auth_params)

            get :sign_in_flow_test, params: params
          end

          it 'redirect to root' do
            expect(response).to redirect_to(root_path)
          end

          it 'set flash message' do
            expect(flash[:notice]).to eq('Successfully authenticated from Any_provider account.')
          end
        end

        context 'when authorization exist and user is unconfirmed' do
          before do
            auth_params[:user] = create(:user, email: email, confirmed_at: nil)
            create(:authorization, auth_params)

            get :sign_in_flow_test, params: params
          end

          it 'redirect to sign in' do
            expect(response).to redirect_to(new_user_session_path)
          end

          it 'set flash message' do
            expect(flash[:alert]).to eq('You have to confirm your email address before continuing.')
          end
        end

        context 'when authorization not exist' do
          before { get :sign_in_flow_test, params: params }
          it 'assign auth.uid to @uid' do
            expect(assigns(:uid)).to eq(params[:uid])
          end

          it 'assign auth.provider to @provider' do
            expect(assigns(:params)).to eq(params[:params])
          end

          it 'render request_email view' do
            expect(response).to render_template('devise/sessions/request_email')
          end
        end
      end
    end
  end
end
