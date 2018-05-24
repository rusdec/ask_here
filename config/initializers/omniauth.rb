Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, Rails.application.secrets.twitter_app_key,
                     Rails.application.secrets.twitter_app_secret,
                     { authorize_params: { force_login: true } }
end
