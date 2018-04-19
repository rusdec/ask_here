require_relative '../features_helper'

feature 'User create answer', %q{
  As user
  I can create answer for question
  so that I can help answer the question
} do

  given(:user) { create(:user_with_questions) }
  given(:question) { user.questions.last }
  given(:answer_body) { 'RandomValidAnswerBodyText' }
  given(:params) do
    { body: answer_body,
      question: question }
  end

  describe 'Authenticated user' do
    before { sign_in(user) }

    scenario 'can create answer with valid data', js: true do
      create_answer(params)

      expect(page).to have_content answer_body
    end

    scenario 'can\'t create answer with invalid data', js: true do
      params[:body] = nil
      create_answer(params)

      expect(page).to have_content 'Body can\'t be blank'
    end
  end

  scenario 'Unauthenticated user can\'t create answer', js: true do
    visit question

    expect(page).to have_no_content('Create Answer')
  end
end
