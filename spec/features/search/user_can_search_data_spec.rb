require_relative '../features_helper'

feature 'User can search data', %q{
  As user
  I can search data
  so that I can find needed data fastest
} do

  context 'Authenticated user' do
    let(:user) { create(:user) }
    let!(:questions) { create_list(:question_with_answers, 2, user: user) }
    let(:question) { questions.last }
    before do
      index
      sign_in(user)
      visit search_path
    end

    context 'when find questions' do

      scenario 'can search by question title', js: true do
        find_by_context(context: 'question', text: question.title)
        expect(page).to have_content(question.title)
        expect(page).to have_content(question.body.truncate(100))
      end

      scenario 'can search by question body', js: true do
        find_by_context(context: 'question', text: question.body)
        expect(page).to have_content(question.title)
        expect(page).to have_content(question.body.truncate(100))
      end

      scenario 'see link to question page', js: true do
        find_by_context(context: 'question', text: question.title)
        expect(page).to have_link(question.title)
      end
    end # context 'when find questions'

    context 'when find answers' do
      let(:answer) { question.answers.last }
      before { find_by_context(context: 'answer', text: answer.body) }

      scenario 'can search by answer body', js: true do
        expect(page).to have_content(question.title)
        expect(page).to have_content(answer.body.truncate(100))
      end

      scenario 'see link to question page', js: true do
        expect(page).to have_link(question.title)
      end
    end # context 'when find answers'

    context 'when find comments' do
      let!(:comment_for_question) do
        create(:comment, user: user, commentable: question,
               body: 'Question CommentBody')
      end

      let!(:comment_for_answer) do
        create(:comment, user: user, commentable: question.answers.last,
               body: 'Answer CommentBody')
      end

      before do
        index
        find_by_context(context: 'comment', text: 'CommentBody')
      end

      scenario 'can search by comment body', js: true do
        expect(page).to have_content(question.title, count: 2)
        expect(page).to have_content(comment_for_question.body.truncate(100))
        expect(page).to have_content(comment_for_answer.body.truncate(100))
      end

      scenario 'see link to question page', js: true do
        expect(page).to have_link(question.title, count: 2)
      end
    end # context 'when find answers'
  end
end
