require_relative '../features_helper'

feature 'Signing in via Github', %q{
  As user
  I can sign in via my Github
  so that I did not have to go through the registration procedure
} do

  context 'Sign in via Github' do
    before { visit new_user_session_path }

    context 'when auth data valid' do
      scenario 'user sign in successful' do
        expect(page).to have_content('Sign in with GitHub')

        mock_github_auth_hash
        click_on 'Sign in with GitHub'
        expect(page).to have_content('Successfully authenticated from Github account.')
      end
    end
  end
end
