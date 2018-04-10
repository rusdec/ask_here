require 'rails_helper'

feature 'User view questions', %q{
  As user
  I can view all questions
  so that I can detail view interesting for me
} do

  given!(:questions) { create(:user_with_questions, questions_count: 3).questions }

  scenario 'User view questions' do
    visit questions_path

    page.all('.question').each do |question|
      expect(question).to have_content('ValidQuestionTitle')
    end

    expect(page.all('.question').count).to eq(questions.count)
  end
end
