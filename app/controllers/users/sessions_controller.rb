class Users::SessionsController < Devise::SessionsController
  include OauthSigned

  def authorization_after_request_email
    request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
      uid: params[:uid],
      provider: params[:provider],
      info: { email: params[:email] },
      with_request_email: true
    )

    sign_in_flow
  end
end
