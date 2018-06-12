require_relative '../features_helper'

feature 'User can search data', %q{
  As user
  I can search data
  so that I can find needed data fastest
} do

  context 'All user' do
    let(:user) { create(:user) }
    let!(:questions) { create_list(:question_with_answers, 2, user: user) }
    let(:question) { questions.last }
    before do
      visit search_path
    end

    scenario 'max view body is 100 characters', js: true do
      question = create(:question, user: user, body: 'BodyText ' << 'text '*100)
      index
      find_by_context(context: 'question', text: 'BodyText')
      expect(page).to have_content(question.body.truncate(100))
    end

    scenario 'query in text input field after reloadpage', js: true do
      find_by_context(context: 'question', text: 'Query must be in input field')
      within '.body' do
        expect(find('[name="query"]').value).to eq('Query must be in input field')
      end
    end

    context 'when find questions' do
      before { index }

      scenario 'can search by question title', js: true do
        find_by_context(context: 'question', text: question.title)
        within '.results' do
          expect(page).to have_content(question.title)
          expect(page).to have_content(question.body.truncate(100))
        end
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
    end # context 'when find all'

    context 'when find by user' do
      before do
        index
        find_by_context(context: 'all', text: user.email)
      end
      
      scenario "find all users resources by user email", js: true do
        questions.each do |question|
          expect(page).to have_link(question.title)
          expect(page).to have_content(question.body)

          question.answers.each do |answer|
            expect(page).to have_content(answer.body)
          end
        end
      end
    end # context 'when find by user'

    context 'when pagination' do
      let(:user) { create(:user) }
      let!(:questions) { create_list(:question, 100, user: user) }

      before do
        index
        find_by_context(context: 'question', text: user.email)
      end

      scenario 'see only first 20 questions', js: true do
        questions[0..19].each do |question|
          expect(page).to have_link(question.title)
          expect(page).to have_content(question.body.truncate(100))
        end

        questions[20..-1].each do |question|
          expect(page).to_not have_link(question.title)
          expect(page).to_not have_content(question.body.truncate(100))
        end
      end

      scenario 'see 30 questions when use per_page', js: true do
        find_by_context(per_page: 50,
                        context: 'question',
                        text: user.email)

        questions[0..49].each do |question|
          expect(page).to have_link(question.title)
        end

        questions[50..-1].each do |question|
          expect(page).to_not have_link(question.title)
        end
      end

      scenario 'user see pagination', js: true do
        within '.pagination' do
          expect(page).to have_content(1)
          expect(page).to have_link(2)
        end
      end

      scenario 'user no see pagination when no result', js: true do
        find_by_context(context: 'question', text: create(:user).email)
        expect(page).to_not have_content(/^1$/)
      end
    end # context 'pagination'
  end
end
