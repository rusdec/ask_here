module Feature
  module OmniauthMacros
    def mock_github_auth_hash
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
        provider: 'github',
        uid: '12345',
        info: { email: 'user@email.ru' }
      })
    end
  end
end
