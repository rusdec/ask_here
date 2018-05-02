require_relative '../features_helper'

feature 'User vote for an answer', %q{
  As authenticated user
  I can once vote for any answer
  so that express one's attitude to the answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given!(:vote) { create(:answer_vote, votable: answer, user: user, value: true) }

  context 'Authenticated user' do
    context 'when author of answer' do
      before do
        sign_in(user)
        visit question_path(question)
      end
=begin
      scenario 'no see vote options for a answer', js: true do
        within '.answers' do
          expect(page).to have_no_button(value: 'Like')
          expect(page).to have_no_button(value: 'Dislike')
        end
      end
      scenario 'can see vote rating of answer', js: true do
        within '.answers' do
          expect(page).to have_content('+1')
        end
      end
=end
    end

    context 'when not author of answer' do
      before do
        sign_in(create(:user))
        visit question_path(question)
      end

      context 'and vote for a answer' do
        scenario 'see vote options', js: true do
          within '.answers' do
            expect(page).to have_button(value: 'Like')
            expect(page).to have_button(value: 'Dislike')
          end
        end

        scenario 'can vote only once', js: true do
          within '.answers' do
            expect(page).to have_content('+1')

            like

            expect(page).to have_content('+2')
          end
        end

        scenario 'can revote', js: true do
          within '.answers' do
            expect(page).to have_content('+1')

            like
            expect(page).to have_content('+2')

            dislike
            expect(page).to have_content('0')
          end
        end

        scenario 'can cancel vote', js: true do
          within '.answers' do
            expect(page).to have_content('+1')

            dislike
            expect(page).to have_content('0')

            dislike
            expect(page).to have_content('+1')
          end
        end
      end

      scenario 'can see vote rating of answer' do
        within '.answers' do
          expect(page).to have_content('+1')
        end
      end
    end
  end

  context 'Unauthenticated user' do
    before { visit question_path(question) }

    scenario 'no see vote options for a answer' do
      within '.answers' do
        expect(page).to have_no_button(value: 'Like')
        expect(page).to have_no_button(value: 'Dislike')
      end
    end

    scenario 'can see vote rating of answer' do
      within '.answers' do
        expect(page).to have_content('+1')
      end
    end
  end
end
