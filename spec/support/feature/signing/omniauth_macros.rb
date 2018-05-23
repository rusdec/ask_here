module Feature
  module OmniauthMacros
    def mock_github_auth_hash
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
        provider: 'github',
        uid: '12345',
        info: { email: sign_in_email }
      )
    end

    def mock_twitter_auth_hash
      OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
        provider: 'twitter',
        uid: '12345',
        info: {}
      )
    end

    def click_sign_in_with(provider)
      click_on "Sign in with #{provider.capitalize}"
    end

    def sign_in_email
      'test@example.com'
    end

    def sign_in_via_twitter
      mock_twitter_auth_hash
      click_sign_in_with('twitter')
    end

    def fill_request_email_form
      fill_request_email_form_with(sign_in_email)
    end

    def fill_request_email_form_with(email = '')
      fill_in 'email', with: email
      click_on 'Send'
    end
  end
end
