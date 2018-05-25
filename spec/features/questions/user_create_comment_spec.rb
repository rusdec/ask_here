require_relative '../features_helper'

feature 'User create comment', %q{
  As authonticated user
  I can create comment to question
  so that i can supplement or clarify anything from the inquirer
} do

  given(:question) { create(:question, user: create(:user)) }

  context 'Authenticated user' do
    before do
      sign_in(create(:user))
      visit question_path(question)
    end

    scenario 'can add comment with valid data', js: true do
      comment_attributes = attributes_for(:comment)
      add_comment(comment_attributes.merge(context: '.question'))

      expect(page).to have_content(comment_attributes[:body])
    end

    scenario 'can\'t add comment with invalid data', js: true do
      add_comment(attributes_for(:invalid_comment).merge(context: '.question'))

      within '.question .new-comment' do
        expect(page).to have_content('Body can\'t be blank')
        expect(page).to have_content('Body is too short (minimum is 10 characters)')
      end
    end
  end


  context 'multiple sessions' do
    let(:comment_attributes) { attributes_for(:comment) }
    let(:answer) { question.answers.last }

    scenario 'comment appears on another user\'s page under it answer', js: true do
      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(create(:user))
        visit question_path(question)
        add_comment(comment_attributes.merge(context: '.question'))
      end

      Capybara.using_session('guest') do
        within '.question' do
          expect(page).to have_content(comment_attributes[:body])
        end
      end
    end

    scenario 'another user no see Edit option for comment', js: true do
      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(create(:user))
        visit question_path(question)
        add_comment(comment_attributes.merge(context: '.question'))
      end

      Capybara.using_session('guest') do
        within '.question' do
          expect(page).to_not have_content('Edit')
        end
      end
    end
  end

  context 'Unauthenticated user' do
    scenario 'no see Add comment link' do
      visit question_path(question)
      
      expect(page).to have_no_content('Add comment')
    end
  end
end
