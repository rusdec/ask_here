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
      before do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'can choose best answer for his question', js: true do
        expect(page).to have_no_selector(best_answer(answer))

        click_set_as_best_answer_link(answer)

        expect(page).to have_selector(best_answer(answer))
      end

      scenario 'see chosen best answer replace on top', js: true do
        top_answer = page.first('.answer .body')

        expect(top_answer.text).to_not match(/#{answer.body}/)

        click_set_as_best_answer_link(answer)
        top_answer = page.first('.answer .body')

        expect(top_answer.text).to match(/#{answer.body}/)
      end
    end

    describe 'when not author of question' do
      scenario 'can\'t choose best answer' do
        sign_in(create(:user))
        visit question_path(question)

        expect(page).to have_no_selector(set_as_best_answer_link)
      end
    end
  end

  scenario 'Unauthenticated user can\'t choose best answer' do
    visit question_path(question)

    expect(page).to have_no_selector(set_as_best_answer_link)
  end

  describe 'Any user' do
    scenario 'can see only one best marker', js: true do
      another_answer = question.answers.first

      sign_in(user)
      visit question_path(question)

      click_set_as_best_answer_link(answer)

      expect(page).to have_selector(best_answer(answer))

      click_set_as_best_answer_link(another_answer)

      expect(page).to have_no_selector(best_answer(answer))
      expect(page).to have_selector(best_answer(another_answer))
    end

    scenario 'can see best answer on top' do
      best_answer = create(:best_answer, user: user, question: question)
      visit question_path(question)
      top_answer = page.first('.answer .body')

      expect(top_answer.text).to match(/#{best_answer.body}/)
    end
  end

end


