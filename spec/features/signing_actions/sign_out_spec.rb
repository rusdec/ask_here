require 'rails_helper'

feature 'Signing out', %q{
  As user
  I can sign out
  so that I have not access to the system
} do
  given(:user) { create(:user) }
  scenario 'Signing out' do
    sign_in(user)

    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
