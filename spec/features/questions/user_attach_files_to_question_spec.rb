require_relative '../features_helper'

feature 'User can attach files to question', %q{
  As author of question
  I can attach any files to question
  so that I can clarify the my problem
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:question_attributes) { attributes_for(:question) }

  describe 'Authenticated user' do
    context 'when author' do
      before { sign_in(user) }

      scenario 'can attach one or more files' do
        visit question_path(question)

        create_question_with_files(question_attributes)

        expect(page).to have_content('restart.txt')
      end
    end

    context 'when not author' do
      before { sign_in(create(:user)) }

      scenario 'no see attach form' do
        visit question_path(question)

        expect(page).to have_no_content('Attach File')
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'no see attach form' do
      visit question_path(question)

      expect(page).to have_no_content('Attach File')
    end
  end
end
