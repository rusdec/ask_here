class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include OauthSigned

  def github
    sign_in_flow
  end

  def twitter
    sign_in_flow
  end
end
