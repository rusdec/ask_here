require_relative '../features_helper'

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
    sign_in(first_user)

    visit question_path(first_user_question)
    
    expect(page).to have_content(first_user_question.title)
    expect(page).to have_content(first_user_question.body)

    click_on 'Delete Question'

    expect(page).to have_content('Question delete success')
    expect(page).to have_no_content(first_user_question.title)
    expect(page).to have_no_content(first_user_question.body)
  end

  scenario 'User can\'t delete question of any user' do
    sign_in(first_user)

    visit question_path(second_user_question)

    expect(page).to have_no_content('Delete')
  end
end
