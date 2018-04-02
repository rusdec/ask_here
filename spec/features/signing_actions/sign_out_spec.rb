require 'rails_helper'

feature 'Signing out', %q{
  As user
  I can sign out
  so that I have not access to the system
} do
  given(:user) { create(:user) }
  scenario 'Signing out' do
    visit '/sign_in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Sign in'

    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
