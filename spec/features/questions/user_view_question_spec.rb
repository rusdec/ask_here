require_relative '../features_helper'

feature 'User view question', %q{
  As user
  I can view any question
  so that I can view this question and all his answers
} do
  given(:user) { create(:user_with_question_and_answers, answers_count: 3) }
  given(:question) { user.questions.last }

  before do
    visit question_path(question)
  end

  scenario 'User view question body' do
    expect(page).to have_content question.body
  end

  scenario 'User view all questions answers' do
    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end

    expect(page.all('.answer').count).to eq(question.answers.count)
  end
end
