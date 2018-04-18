require_relative '../features_helper'

feature 'User delete question', %q{
  As author of question
  only I can delete my qustions
  so that other users can't delete my question
} do

  given(:user) { create(:user_with_questions) }
  given(:question) { user.questions.last }

  describe 'Authenticated user' do
    scenario 'can delete his question', js: true do
      sign_in(user)
      visit question_path(question)
      
      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)

      click_on 'Delete'

      expect(page).to have_no_content(question.title)
      expect(page).to have_no_content(question.body)
    end

    scenario 'can\'t delete question of any user', js: true do
      sign_in(create(:user))
      visit question_path(question)

      expect(page).to have_no_content('Delete')
    end
  end

  scenario 'Unauthenticated user can\'t delete question', js: true do
    visit question_path(question)

    expect(page).to have_no_content('Delete')
  end
end
