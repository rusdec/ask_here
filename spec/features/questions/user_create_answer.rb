require 'rails_helper'

feature 'User create answer', %q{
  As user
  I can create answer for question
  so that I can help answer the question
} do

  given(:question) { create(:question) }
  given(:user) { create(:user) }

  scenario 'User create answer with valid data' do
    visit sign_in_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Sign in'

    visit question_path(question)
    fill_in 'Body', with: 'ValidAnswerBodyText'
    click_on 'Create Answer'

    expect(page).to have_content 'ValidAnswerBodyText'
  end

  scenario 'User create answer with invalid data' do
    visit sign_in_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Sign in'

    visit question_path(question)
    fill_in 'Body', with: nil
    click_on 'Create Answer'

    expect(page).to have_content 'Errors:'
  end

  scenario 'Non auth user don\'t create answer with invalid data' do
    visit question_path(question)
    fill_in 'Body', with: 'ValidAnswerBodyText'
    click_on 'Create Answer'

    expect(page).to have_content('Log in')
  end
end
