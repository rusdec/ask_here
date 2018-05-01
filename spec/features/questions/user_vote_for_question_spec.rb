require_relative '../features_helper'

feature 'User vote for a question', %q{
  As authenticated user
  I can once vote for any question
  so that express one's attitude to the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:vote) { create(:question_vote,
                         votable: question,
                         user: create(:user),
                         value: true) }

  context 'Authenticated user' do
    before { sign_in(user) }

    context 'when author of question' do
      before { visit question_path(question) }

      scenario 'no see vote options for a question', js: true do
        expect(page).to have_no_button(value: 'Like')
        expect(page).to have_no_button(value: 'Dislike')
      end

      scenario 'can see vote rating of question', js: true do
        expect(page).to have_content('+1')
        sleep 5
      end
    end

    context 'when not author of question' do
      given(:question) { create(:question, user: create(:user)) }
      before { visit question_path(question) }

      context 'and vote for a question' do

        scenario 'see vote options', js: true do
          expect(page).to have_button(value: 'Like')
          expect(page).to have_button(value: 'Dislike')
        end

        scenario 'can vote only once', js: true do
          expect(page).to have_content('+1')

          like(context: '.question')

          expect(page).to have_content('+2')
        end

        scenario 'can revote', js: true do
          expect(page).to have_content('+1')

          like(context: '.question')
          expect(page).to have_content('+2')

          dislike(context: '.question')
          expect(page).to have_content('0')
        end

        scenario 'can cancel vote', js: true do
          expect(page).to have_content('+1')

          dislike(context: '.question')
          expect(page).to have_content('0')

          dislike(context: '.question')
          expect(page).to have_content('+1')
        end
      end

      scenario 'can see vote rating of question' do
        expect(page).to have_content('+1')
      end
    end
  end

  context 'Unauthenticated user' do
    before { visit question_path(question) }

    scenario 'no see vote options for a question' do
      expect(page).to have_no_button(value: 'Like')
      expect(page).to have_no_button(value: 'Dislike')
    end

    scenario 'can see vote rating of question' do
      expect(page).to have_content('+1')
    end
  end
end
