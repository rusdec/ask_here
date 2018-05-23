require_relative '../features_helper'

feature 'Signing up', %q{
  As user
  I want to registered
  So that I can sign in
} do
  given(:params) do
    { email: 'example@email.ru',
      password: 'Qwerty12345',
      password_confirmation: 'Qwerty12345' }
  end

  scenario 'Registration with correct data' do
    sign_up(params)

    expect(page).to have_content I18n.t('devise.registrations.signed_up')
  end

  scenario 'Registration with incorrect data' do
    params[:email] = nil
    sign_up(params)

    expect(page).to have_content 'Email can\'t be blank'
  end
end
