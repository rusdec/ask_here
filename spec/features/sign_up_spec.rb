require 'rails_helper'

feature 'Signing up', %q{
  As user
  I want to registered
  So that I can sign in
} do
  scenario 'Registration with correct data' do
    visit new_user_registration_path
    fill_in 'Email', with: 'example@email.ru'
    fill_in 'Password', with: 'Qwerty123'
    fill_in 'Password confirmation', with: 'Qwerty123'

    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
  scenario 'Registration with incorrect data' do
    visit new_user_registration_path
    fill_in 'Email', with: 'example@email'
    fill_in 'Password', with: ''
    fill_in 'Password confirmation', with: 'Q'

    click_on 'Sign up'
    expect(page).to have_content 'errors prohibited this user from being saved'
  end
end
