require_relative '../features_helper'

feature 'User update question', %q{
  As user
  I can edit answer
  so that I can change him
} do

  given(:user) { create(:user_with_question_and_answers) }
  given(:another_user) { create(:user_with_question_and_answers) }
  given(:question) { user.questions.last }
  given(:answer) { question.answers.last }

  describe 'Authenticated user' do
    before { sign_in(user) }

    scenario 'can update answer with valid data', js: true do
      new_body = 'NewAnswerValidBody'
      update_answer(question: question, answer: answer, body: new_body)

      expect(page).to have_selector(answer_body(answer), text: new_body)
    end

    scenario 'can\'t update answer with invalid data', js: true do
      update_answer(question: question, answer: answer, body: nil)

      expect(page).to have_content('Body can\'t be blank')
    end

    scenario 'can\'t edit answer of another user' do
      another_question = another_user.questions.last
      another_answer = another_question.answers.last
      visit question_path(another_question)

      expect(page).to have_no_selector(answer_edit_form(another_answer))
      expect(page).to have_no_selector(answer_edit_link(another_answer))
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can\'t edit question' do
      visit question_path(question)

      expect(page).to have_no_selector(answer_edit_link(answer))
      expect(page).to have_no_selector(answer_edit_form(answer))
    end
  end

end