require_relative '../features_helper'

feature 'User create comment', %q{
  As authonticated user
  I can create commnent to answer
  so that i can supplement or clarify anything from the inquirer
} do

  given(:question) { create(:question, user: create(:user)) }
  before { create(:answer, user: create(:user), question: question) }

  context 'Authenticated user' do
    before do
      sign_in(create(:user))
      visit question_path(question)
    end

    scenario 'can add comment with valid data', js: true do
      comment_attributes = attributes_for(:comment)
      add_comment(comment_attributes.merge(context: '.answers'))

      expect(page).to have_content(comment_attributes[:body])
    end

    scenario 'can\'t add comment with invalid data', js: true do
      add_comment(attributes_for(:invalid_comment).merge(context: '.answers'))

      expect(page).to have_content('Body can\'t be blank')
      expect(page).to have_content('Body is too short (minimum is 10 characters)')
    end
  end

  context 'Unauthenticated user' do
    scenario 'can\'t create comment' do
      visit question_path(question)
      
      expect(page).to have_no_content('Add comment')
    end
  end
end
