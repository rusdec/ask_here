require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do

  describe 'GET #authorization_after_request_email' do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      get :authorization_after_request_email, params: { uid: '12345',
                                                        provider: 'any_provider',
                                                        email: 'example@email.com' }
    end

    it 'redirect to sign in' do
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'set flash message' do
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unconfirmed'))
    end
  end

end
