require_relative '../features_helper'

feature 'User update question', %q{
  As user
  I can edit answer
  so that I can change him
} do

  given(:user) { create(:user_with_question_and_answers, answers_count: 1) }
  given(:question) { user.questions.last }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    context 'when author of answer' do
      given(:answer) { question.answers.last }

      scenario 'can update answer with valid data', js: true do
        new_body = 'NewAnswerValidBody'
        update_answer(answer: answer, body: new_body)

        expect(page).to have_content(new_body)
      end

      scenario 'can\'t update answer with invalid data', js: true do
        update_answer(answer: answer, body: nil)

        expect(page).to have_content('Body can\'t be blank')
      end

      context 'when click Edit link' do
        scenario 'no see Edit link anymore', js: true do
          within '.answers' do
             expect(page).to have_content('Edit')
             click_on 'Edit'
             expect(page).to have_no_content('Edit')
          end
        end

        scenario 'see Cancel link', js: true do
          within '.answers' do
            expect(page).to have_no_content('Cancel')
            click_on 'Edit'
            expect(page).to have_content('Cancel')
          end
        end
      end

      context 'when click Cancel link' do
        scenario 'no see Cancel link anymore', js: true do
          within '.answers' do
            click_on 'Edit'
            click_on 'Cancel'
            expect(page).to have_no_content('Cancel')
          end
        end

        scenario 'see Edit link', js: true do
          within '.answers' do
            click_on 'Edit'
            click_on 'Cancel'
            expect(page).to have_content('Edit')
          end
        end
      end
    end

    context 'when not author of answer' do
      scenario 'can\'t edit answer of another user' do
        visit question_path(create(:question, user: create(:user)))

        expect(page).to have_no_content('Edit')
      end
    end

  end
=begin
  context 'Unauthenticated user' do
    before { visit question_path(question) }

    scenario 'can\'t edit question' do
      expect(page).to have_no_content('Edit')
    end
  end
=end
end
