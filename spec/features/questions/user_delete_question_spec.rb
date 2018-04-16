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

  scenario 'Unauthorized user can\'t delete question', js: true do
    visit question_path(first_user_question)
    expect(page).to have_no_selector('.link-delete-question')
  end

  scenario 'Authenticated user can delete his question', js: true do
    sign_in(first_user)

    visit question_path(first_user_question)
    
    expect(page).to have_content(first_user_question.title)
    expect(page).to have_content(first_user_question.body)

    click_delete_link

    expect(page).to have_no_content(first_user_question.title)
    expect(page).to have_no_content(first_user_question.body)
  end

  scenario 'Authonticated user can\'t delete question of any user', js: true do
    sign_in(first_user)

    visit question_path(second_user_question)

    expect(page).to have_no_selector('.link-delete-question')
  end
end
