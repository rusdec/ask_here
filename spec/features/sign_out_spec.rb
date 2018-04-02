require 'rails_helper'

feature 'Signing out', %q{
  As user
  I can sign out
  so that I have not access to the system
} do
  scenario 'Signing out' do
    visit root_path
    click_on 'Sign out'

    expect(page).to have_content 'Sign out success!'
  end
end
