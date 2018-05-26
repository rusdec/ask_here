require_relative '../features_helper'

feature 'User create answer', %q{
  As user
  I can create answer for question
  so that I can help answer the question
} do

  given(:user) { create(:user_with_questions) }
  given(:question) { user.questions.last }
  given(:answer_attributes) { attributes_for(:answer) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can create answer with valid data', js: true do
      create_answer(answer_attributes)

      expect(page).to have_content(answer_attributes[:body])
    end

    scenario 'can\'t create answer with invalid data', js: true do
      create_answer(attributes_for(:invalid_answer))

      expect(page).to have_content 'Body can\'t be blank'
    end
  end

  context 'Unauthenticated user' do
    before { visit question_path(question) }

    scenario 'no see Create answer link' do
      expect(page).to have_no_content('Create Answer')
    end
  end

  context 'multiple sessions' do
    scenario 'answer appears on another user\'s page', js: true do
      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
        create_answer(answer_attributes)
      end

      Capybara.using_session('guest') do
        expect(page).to have_content(answer_attributes[:body])
      end
    end
  end
end
