require_relative '../features_helper'

feature 'User update comment', %q{
  As authonticated user
  I can update answers comment
  so that i can supplement or clarify anything from the inquirer
} do

  given(:question) { create(:question, user: create(:user)) }
  given(:answer) { create(:answer, user: create(:user), question: question) }
  given(:comment_author) { create(:user) }
  given(:new_body) { 'NewValidCommentBodyText' }
  given!(:comment) { create(:comment, user: comment_author, commentable: answer) }

  context 'Authenticated user' do
    context 'when author of comment' do
      before do
        sign_in(comment_author)
        visit question_path(question)
      end

      scenario 'can update comment with valid data', js: true do
        update_comment(context: comment_container(comment), body: new_body)

        expect(page).to have_content(new_body)
      end

      scenario 'can\'t update comment with invalid data', js: true do
        update_comment(context: comment_container(comment), body: nil)

        within comment_container(comment) do
          expect(page).to have_content('Body can\'t be blank')
          expect(page).to have_content('Body is too short (minimum is 10 characters)')
        end
      end
    end

    context 'when not author of comment' do
      before do
        sign_in(create(:user))
        visit question_path(question)
      end

      scenario 'no see Edit option for comment', js: true do
        within(comment_container(comment)) do
          expect(page).to_not have_content('Edit')
        end
      end
    end
  end

  context 'multiple sessions' do
    scenario 'comment update on another user\'s page under it answer', js: true do
      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(comment_author)
        visit question_path(question)
        update_comment(context: '.answers .comments', body: new_body)
      end

      Capybara.using_session('guest') do
        within answer_container(answer) do
          expect(page).to have_content(new_body)
        end
      end
    end

    scenario 'another user no see Edit option for comment', js: true do
      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(comment_author)
        visit question_path(question)
        update_comment(context: '.answers .comments', body: new_body)
      end

      Capybara.using_session('guest') do
        within answer_container(answer) do
          expect(page).to_not have_content('Edit')
        end
      end
    end
  end

  context 'Unauthenticated user' do
    scenario 'no see Edit option' do
      visit question_path(question)
      expect(page).to have_no_content('Edit')
    end
  end
end
