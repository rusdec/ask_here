require 'rails_helper'

feature 'User view questions', %q{
  As user
  I can view all questions
  so that I can detail view interesting for me
} do

  before { create(:user_with_questions, questions_count: 3) }

  scenario 'User view questions' do
    visit questions_path

    expect(page).to have_content('ValidQuestionTitle')
  end
end
