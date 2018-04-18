require_relative '../features_helper'

feature 'User delete answer', %q{
  As author of answer
  only I can delete my answers
  so that other users can't delete my answer
} do

  given(:user) { create(:user_with_question_and_answers) }
  given(:question) { user.questions.last }
  given(:answer) { user.answers.last }
  given(:answer_body) { answer.body }

  describe 'Authenticated user' do
    describe 'when author of answer' do
      scenario 'can delete answer', js: true do
        sign_in(user)
        visit question_path(question)

        expect(page).to have_content(answer_body)

        click_delete_answer_link(answer)

        expect(page).to have_no_content(answer_body)
      end
    end

    describe 'when not author of answer' do
      scenario 'no see delete link for answer' do
        sign_in(create(:user))
        visit question_path(question)
        
        expect(page).to have_no_content('Delete')
      end
    end
  end

  scenario 'Unauthenticated user no see delete answer links' do
    visit question_path(question)
    
    expect(page).to have_no_content('Delete')
  end
end
