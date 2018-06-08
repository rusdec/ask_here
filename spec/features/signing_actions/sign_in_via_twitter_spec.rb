require_relative '../features_helper'

feature 'Signing in via Twitter', %q{
  As user
  I can sign in via my Twitter
  so that I did not have to go through the registration procedure
} do

  context 'Sign in via Twitter' do
    before { visit new_user_session_path }

    scenario 'user see twitter sign in link' do
      expect(page).to have_content('Sign in with Twitter')
    end

    context 'when user is created and confirmed' do
      scenario 'it can sign in without mail request' do
        sign_in_via_twitter
        fill_request_email_form

        open_email(sign_in_email)
        current_email.click_on('Confirm my account')
        clear_email

        visit new_user_session_path
        sign_in_via_twitter

        expect(page).to have_content('Sign out')
      end
    end

    context 'when user is created but not confirmed' do
      scenario 'can\'t sign in' do
        sign_in_via_twitter
        fill_request_email_form

        click_sign_in_with('twitter')

        expect(page).to have_content('Sign in')
        expect(page).to have_content('You have to confirm your email address before continuing')
      end
    end

    context 'when user is not created' do
      scenario 'see request email form' do
        sign_in_via_twitter

        expect(page).to have_content('Enter your Email')
      end

      context 'and user send own email' do
        context 'when email valid' do
          before do
            sign_in_via_twitter
            fill_request_email_form
          end

          scenario 'see confirm email message' do
            expect(page).to have_content('You have to confirm your email address before continuing.')
          end

          scenario 'not signed yet' do
            expect(page).to have_content('Sign in')
          end

          context 'receive email' do
            scenario 'see confirmation email' do
              open_email(sign_in_email)

              expect(current_email.subject).to eq('Confirmation instructions')
              expect(current_email).to have_content('Confirm my account')

              clear_emails
            end

            scenario 'can confirm through link contained email' do
              open_email(sign_in_email)
              current_email.click_on 'Confirm my account'

              expect(page).to have_content('Your email address has been successfully confirmed')

              clear_emails
            end
          end
        end

        context 'when email invalid' do
          before do
            sign_in_via_twitter
            fill_request_email_form_with
          end

          scenario 'user not sign in' do
            expect(page).to have_content('Sign in')
          end

          scenario 'user see errors' do
            expect(page).to have_content("Email can't be blank")
          end
        end
      end
    end
  end
end
