require 'rails_helper'

feature 'User view question', %q{
  As user
  I can view any question
  so that I can view this question and all his answers
} do
  given(:question) { create(:question) }

  before do
    create_list(:answer, 3, question: question)
    visit question_path(question)
  end

  scenario 'User view question body' do
    expect(page).to have_content 'ValidQuestionBodyText'
  end

  scenario 'User view answers' do
    expect(page).to have_content 'ValidAnswerBodyText'
  end
end
