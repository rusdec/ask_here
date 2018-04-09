require 'rails_helper'

feature 'User create answer', %q{
  As user
  I can create answer for question
  so that I can help answer the question
} do

  given(:user) { create(:user_with_questions) }
  given(:question) { user.questions.last }

  scenario 'User create answer with valid data' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: 'ValidAnswerBodyText'
    click_on 'Create Answer'

    expect(page).to have_content 'ValidAnswerBodyText'
  end

  scenario 'User create answer with invalid data' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: nil
    click_on 'Create Answer'

    expect(page).to have_content 'Errors:'
  end

  scenario 'Non authorized user don\'t create answer' do
    visit question_path(question)
    fill_in 'Body', with: 'ValidAnswerBodyText'
    click_on 'Create Answer'

    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end
end
