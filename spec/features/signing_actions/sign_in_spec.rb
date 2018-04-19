require_relative '../features_helper'

feature 'Signing in', %q{
  As user
  I can sign in
  so that I can ask questions and get answers
} do

  given(:user) { create(:user) }

  scenario 'Sign in display when user not authenticated' do
    visit root_path
    expect(page).to have_content('Sign in')

    sign_in(user)
    expect(page).to have_no_content('Sign in')
  end

  scenario 'Signing in with correct data' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Signing in with incorrect data' do
    user.email = nil
    sign_in(user)

    expect(page).to have_content 'Invalid Email or password.'
  end
end
