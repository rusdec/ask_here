require 'rails_helper'

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

  scenario 'User create answer with valid data' do
    sign_in(user)
    create_answer(params)

    expect(page).to have_content answer_body
  end

  scenario 'User create answer with invalid data' do
    sign_in(user)
    params[:body] = nil
    create_answer(params)

    expect(page).to have_content 'Body can\'t be blank'
  end

  scenario 'Not authenticated user don\'t create answer' do
    create_answer(params)

    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end
end
