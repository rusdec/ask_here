module OauthSigned
   extend ActiveSupport::Concern

   included do
     def authorization_after_request_email
       request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
         uid: params[:uid],
         provider: params[:provider],
         info: { email: params[:email] },
         with_request_email: true
       )

       sign_in_flow
     end

     private

     def sign_in_flow
       # email exist
       if email_exist?(request.env['omniauth.auth'])
         try_to_sign_in

       # email not exist
       else
         authorization = Authorization.find_by(provider: provider_from(request),
                                               uid: uid_from(request))

         # user with uid and provider exist and confirmed
         if authorization && authorization.user.confirmed?
           request.env['omniauth.auth'].info.email = authorization.user.email
           try_to_sign_in

         # user with uid and provider exist and unconfirmed yet
         elsif authorization && !authorization.user.confirmed?
           redirect_to new_user_session_path, alert: t('devise.failure.unconfirmed')

         # user with uid and provider not exist
         else
           @uid, @provider = uid_from(request), provider_from(request)
           render 'devise/sessions/request_email'
         end
       end
     end

     def try_to_sign_in
       @user = User.find_for_oauth(request.env['omniauth.auth'])
       if @user.errors.any?
         flash[:alerts] = @user.errors.full_messages
         redirect_to new_user_session_path
       else
         sign_in_and_redirect @user, event: :authentication
         if is_navigational_format?
           set_flash_message(:notice, :success,
                             kind: provider_from(request).capitalize)
         end
       end
     end

     def email_exist?(auth)
       auth.info && !auth.info.email.nil?
     end

     def provider_from(auth)
       auth.env['omniauth.auth'].provider
     end

     def uid_from(auth)
       auth.env['omniauth.auth'].uid
     end
   end
end
