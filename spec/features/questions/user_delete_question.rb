require 'rails_helper'

feature 'User delete question', %q{
  As author of question
  only I can delete my qustions
  so that other users can't delete my question
} do

  given(:first_user) { create(:user_with_questions) }
  given(:first_user_question) { first_user.questions.last }

  given(:second_user) { create(:user_with_questions) }
  given(:second_user_question) { second_user.questions.last }

  scenario 'Unauthorized user can\'t delete question' do
    visit new_user_session_path
    expect(page).to have_no_content('Delete')
  end

  scenario 'Author can delete his question' do
    visit new_user_session_path
    fill_in 'Email', with: first_user.email
    fill_in 'Password', with: first_user.password
    click_on 'Sign in'

    visit question_path(first_user_question)
    click_on 'Delete Question'
    expect(page).to have_content('success')
  end

  scenario 'User can\'t delete question of any user' do
    visit new_user_session_path
    fill_in 'Email', with: first_user.email
    fill_in 'Password', with: first_user.password
    click_on 'Sign in'

    visit question_path(second_user_question)
    expect(page).to have_no_content('Delete')
  end
end
