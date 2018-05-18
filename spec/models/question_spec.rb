require_relative 'models_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'attachable'
  it_behaves_like 'userable'
  it_behaves_like 'commentable'

  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }

  it do
    should validate_length_of(:title).
      is_at_least(10).is_at_most(30)
  end
  it do
    should validate_length_of(:body).
      is_at_least(10).is_at_most(1000)
  end

  it 'created answers count should be equal 2' do
    answers_count = 2
    user = create(:user_with_question_and_answers, answers_count: answers_count)
    question = user.questions.last
    question.answers.new

    expect(question.persisted_answers.count).to eq(answers_count)
  end

  it 'select only best answers' do
    question = create(:user_with_question_and_best_answer).questions.last
    best_answers_count = question.answers.where(best: true).count

    expect(question.best_answers.count).to eq(best_answers_count)
  end
end
