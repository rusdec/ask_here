require_relative '../features_helper'

feature 'User update question', %q{
  As user
  I can edit question
  so that I can change him
} do

  given(:user) { create(:user_with_questions) }
  given(:another_user) { create(:user_with_questions) }
  given(:question) { user.questions.last }

  describe 'Authenticated user' do
    before { sign_in(user) }

    scenario 'can update question with valid data', js: true do
      new_body = 'NewQuestionValidBody'
      new_title = 'NewQuestionValidTitle'

      update_question(question: question, title: new_title, body: new_body)

      expect(page).to have_selector('.question .title', text: new_title)
      expect(page).to have_selector('.question .body', text: new_body)
    end

    scenario 'can\'t update question with invalid data', js: true do
      update_question(question: question, title: nil, body: nil)

      expect(page).to have_content('Title can\'t be blank')
      expect(page).to have_content('Body can\'t be blank')
    end

    scenario 'can\'t edit question of another user' do
      visit question_path(another_user.questions.last)

      expect(page).to have_no_selector('.link-edit-question')
      expect(page).to have_no_selector('.form-edit-question')
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can\'t edit question' do
      visit question_path(question)

      expect(page).to have_no_selector('.link-edit-question')
      expect(page).to have_no_selector('.form-edit-question')
    end
  end

end
