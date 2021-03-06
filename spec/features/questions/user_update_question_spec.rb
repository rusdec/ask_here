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

    context 'when author of question' do 
      scenario 'can update question with valid data', js: true do
        new_body = 'NewQuestionValidBody'
        new_title = 'NewQuestionValidTitle'

        update_question(question: question, title: new_title, body: new_body)

        expect(page).to have_content(new_title)
        expect(page).to have_content(new_body)
      end

      scenario 'can\'t update question with invalid data', js: true do
        update_question(question: question, title: nil, body: nil)

        expect(page).to have_content('Title can\'t be blank')
        expect(page).to have_content('Body can\'t be blank')
      end
    end

    context 'when not author of question' do
      scenario 'no see edit question options' do
        visit question_path(another_user.questions.last)

        expect(page).to have_no_content('Edit')
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'no see edit question options' do
      visit question_path(question)

      expect(page).to have_no_content('Edit')
    end
  end
end
