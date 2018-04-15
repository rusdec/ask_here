require_relative '../features_helper'

feature 'User update question', %q{
  As user
  I can edit question
  so that I can change him
} do

  given(:user) { create(:user_with_questions) }
  given(:question) { user.questions.last }

  scenario 'User update question with valid data', js: true do
    new_body = 'NewQuestionValidBody'
    new_title = 'NewQuestionValidTitle'

    sign_in(user)
    update_question(question: question, title: new_title, body: new_body)

    expect(page).to have_selector('.question .title', text: new_title)
    expect(page).to have_selector('.question .body', text: new_body)
  end

  scenario 'User can\'t update question with invalid data', js: true do
    sign_in(user)
    update_question(question: question, title: nil, body: nil)

    expect(page).to have_content('Title can\'t be blank')
    expect(page).to have_content('Body can\'t be blank')
  end

  scenario 'User can\'t update not your question' do
    another_user = create(:user_with_questions)

    sign_in(user)
    visit question_path(another_user.questions.last)

    expect(page).to have_no_content('Edit')
  end

  scenario 'Not authenticated user can\'t update question' do
    visit question_path(question)

    expect(page).to have_no_content('Edit')
  end

  describe 'When user click Edit' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'see fast edit question form' do
      expect(page).to have_selector('.form-edit-question', visible: false)
      click_edit_link
      expect(page).to have_selector('.form-edit-question', visible: true)
    end

    scenario 'no see unediting question data' do
      expect(page).to have_selector('.question', visible: true)
      click_edit_link
      expect(page).to have_selector('.form-edit-question', visible: false)
    end
  end

  describe 'When user click Cancel on fast edit question form' do
    before do
      sign_in(user)
      visit question_path(question)
      click_edit_link
      click_cancel_link
    end

    scenario 'see unediting question data' do
      expect(page).to have_selector('.question', visible: true)
    end

    scenario 'no see fast edit question form' do
      expect(page).to have_selector('.form-edit-question', visible: false)
    end
  end
end
