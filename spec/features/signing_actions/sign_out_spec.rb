require 'rails_helper'

feature 'Signing out', %q{
  As user
  I can sign out
  so that I have not access to the system
} do
  given(:user) { create(:user) }

  scenario 'Sign out display when user authorized' do
    visit root_path
    expect(page).to have_no_content('Sign out')

    sign_in(user)
    expect(page).to have_content('Sign out')
  end

  scenario 'Signing out' do
    sign_in(user)

    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end

end
