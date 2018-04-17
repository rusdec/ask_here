require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }

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

    expect(question.created_answers.count).to eq(answers_count)
  end

  it 'select only best answers' do
    question = create(:user_with_question_and_best_answer).questions.last
    best_answers_count = question.answers.where(best: true).count

    expect(question.best_answers.count).to eq(best_answers_count)
  end

  it 'unckeck best answers' do
    question = create(:user_with_question_and_best_answer).questions.last

    expect {
      question.uncheck_best_answers
    }.to change(question.best_answers, :count).by(-1)
  end
end
