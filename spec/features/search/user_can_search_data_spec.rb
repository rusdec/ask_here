require_relative '../features_helper'

feature 'User can search data', %q{
  As user
  I can search data
  so that I can find needed data fastest
} do

  context 'Authenticated user' do
    let(:user) { create(:user) }
    before do
      sign_in(user)
      visit search_path
    end

    context 'when find questions' do
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question) { questions.last }
      before { index }
      before { page.select 'question', from: 'resource' }

      scenario 'can search by question title', js: true do
        fill_in 'query', with: question.title
        click_on 'Find'

        expect(page).to have_content(question.title)
        expect(page).to have_content(question.body.truncate(100))
      end

      scenario 'can search by question body', js: true do
        fill_in 'query', with: question.body
        click_on 'Find'

        expect(page).to have_content(question.title)
        expect(page).to have_content(question.body)
      end

      scenario 'see link to question page', js: true do
        fill_in 'query', with: question.title
        click_on 'Find'

        expect(page).to have_link(question.title)
      end
    end # context 'when find questions'

    context 'when find answers' do
      let!(:questions) { create_list(:question_with_answers, 2, user: user) }
      let(:question) { questions.last }
      let(:answer) { question.answers.last }
      before { index }
      before { page.select 'answer', from: 'resource' }

      scenario 'can search by answer body', js: true do
        fill_in 'query', with: answer.body
        click_on 'Find'

        expect(page).to have_content(question.title)
        expect(page).to have_content(answer.body.truncate(100))
      end

      scenario 'see link to question page', js: true do
        fill_in 'query', with: question.title
        click_on 'Find'

        expect(page).to have_link(question.title)
      end
    end
  end
end
