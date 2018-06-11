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
      sign_in(user)
      visit search_path
    end

    context 'when find questions' do
      before { index }

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
      before do
        index
        find_by_context(context: 'answer', text: answer.body)
      end

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

    context 'when find all' do
      let(:text) { ' SharedBodyText' }
      let!(:question) { create(:question, user: user, body: 'Question' << text) }
      let!(:answer) do
        create(:answer, question: question, user: user, body: 'Answer' << text)
      end
      let!(:comment_for_question) do
        create(:comment, commentable: question, user: user,
               body: 'Question Comment' << text)
      end

      let!(:comment_for_answer) do
        create(:comment, commentable: question, user: user,
               body: 'Answer Comment' << text)
      end

      before do
        index
        find_by_context(context: 'all', text: text)
      end

      scenario 'see links to question page', js: true do
        expect(page).to have_link(question.title, count: 4)
      end

      scenario 'see body of each finded resorces', js: true do
        [question,
         answer,
         comment_for_question,
         comment_for_answer].each do |resource|
          expect(page).to have_content(resource.body)
        end
      end
    end
  end
end
