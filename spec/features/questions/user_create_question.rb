require 'rails_helper'

feature 'User create question', %q{
  As user
  I can create question
  so that I can get help
} do

  given(:question) { attributes_for(:question) }
  given(:user) { create(:user) }

  scenario 'User create question with valid data' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Sign in'

    visit new_question_path
    fill_in 'Title', with: question[:title]
    fill_in 'Body', with: question[:body]
    click_on 'Create Question'

    expect(page).to have_content('success')
  end

  scenario 'User can\'t create question with invalid data' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Sign in'

    visit new_question_path
    fill_in 'Title', with: nil
    fill_in 'Body', with: nil
    click_on 'Create Question'

    expect(page).to have_content('Errors:')
  end

  scenario 'Unauthorized user can\'t create question' do
    visit new_question_path

    expect(page).to have_content('Log in')
  end
end
