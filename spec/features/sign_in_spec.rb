require 'rails_helper'

feature 'Signing in', %q{
  As user
  I can sign in
  so that I can ask questions and get answers
} do

  given(:user) { create(:user) }

  scenario 'Signing in with correct data' do

    visit '/sign_in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Sign In'

    expect(page).to have_content 'You are welcome!'
  end

  scenario 'Signing in with incorrect data' do
    visit '/sign_in'
    fill_in 'Email', with: nil
    fill_in 'Password', with: user.password
    click_on 'Sign In'

    expect(page).to have_content 'Error!'
  end
end
