module OmniauthMacros
  def any_provider_auth_hash(email = nil)
    email ||= 'example@mail.com'
    OmniAuth::AuthHash.new(
      provider: 'any_provider',
      uid: '123456',
      info: { email: email }
    )
  end

  def any_provider_auth_hash_without_email
    OmniAuth::AuthHash.new(provider: 'any_provider', uid: '123456')
  end
end
