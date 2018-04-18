require_relative '../features_helper'

feature 'User view questions', %q{
  As user
  I can view all questions
  so that I can detail view interesting for me
} do

  given!(:questions) do
    create(:user_with_questions, questions_count: 3).questions
  end

  scenario 'User view questions' do
    visit questions_path
    questions.each do |question|
      expect(page).to have_content(question.title)
    end

    expect(page.all('.question').count).to eq(questions.count)
  end
end
