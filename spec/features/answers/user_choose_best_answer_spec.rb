require_relative '../features_helper'

feature 'User choose best answer', %q{
  As author of question
  I can choose a one best answer
  so that other users find the solution faster
} do

  given(:user) { create(:user_with_question_and_answers, answers_count: 2) }
  given(:question) { user.questions.last }
  given(:answer) { question.answers.last }

  describe 'Authenticated user' do
    describe 'when author of question' do
      before { sign_in(user) }

      scenario 'can choose best answer', js: true do
        visit question_path(question)
        top_answer = page.first('.answer .body')

        expect(top_answer.text).to_not match(/#{answer.body}/)

        click_set_as_best_answer_link(answer)
        top_answer = page.first('.answer .body')

        expect(top_answer.text).to match(/#{answer.body}/)
      end

      scenario 'can choose other best answer', js: true do
        create(:best_answer, user: user, question: question)
        visit question_path(question)

        expect(page).to have_content('Not a Best', count: 1)

        click_set_as_best_answer_link(answer)

        expect(page).to have_content('Not a Best', count: 1)
      end

      scenario 'can cancel best answer', js: true do
        best_answer = create(:best_answer, user: user, question: question)
        visit question_path(question)

        expect(page).to have_content('Not a Best', count: 1)

        click_set_as_not_best_answer_link(best_answer)

        expect(page).to have_no_content('Not a Best')
      end
    end

    describe 'when not author of question' do
      scenario 'can\'t choose best answer' do
        sign_in(create(:user))
        visit question_path(question)

        expect(page).to have_no_content('Best answer')
      end
    end
  end

  scenario 'Unauthenticated user can\'t choose best answer' do
    visit question_path(question)

    expect(page).to have_no_content('Best answer')
  end

  describe 'Any user' do
    scenario 'can see best answer on top' do
      best_answer = create(:best_answer, user: user, question: question)
      visit question_path(question)
      top_answer = page.first('.answer .body')

      expect(top_answer.text).to match(/#{best_answer.body}/)
    end
  end
end
