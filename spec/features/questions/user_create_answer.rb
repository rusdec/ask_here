require 'rails_helper'

feature 'User create answer', %q{
  As user
  I can create answer for question
  so that I can help answer the question
} do

  given(:question) { create(:question) }
  before { visit question_path(question) }

  scenario 'User create answer with valid data' do
    fill_in 'Body', with: 'ValidAnswerBodyText'
    click_on 'Create Answer'

    expect(page).to have_content 'ValidAnswerBodyText'
  end

  scenario 'User create answer with invalid data' do
    fill_in 'Body', with: nil
    click_on 'Create Answer'

    expect(page).to have_content 'Errors:'
  end
end
