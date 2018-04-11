require 'rails_helper'

feature 'Signing up', %q{
  As user
  I want to registered
  So that I can sign in
} do
  given(:params) do
    { email: 'example@email.ru',
      password: 'Qwerty123',
      password_confirmation: 'Qwerty123' }
  end

  scenario 'Registration with correct data' do
    sign_up(params)

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
  scenario 'Registration with incorrect data' do
    params[:email] = nil
    sign_up(params)

    expect(page).to have_content 'Email can\'t be blank'
  end
end
