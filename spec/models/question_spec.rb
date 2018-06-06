require_relative 'models_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'attachable'
  it_behaves_like 'userable'
  it_behaves_like 'commentable'
  it_behaves_like 'subscribable'

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

  context '.new_for_the_last_day' do
    let!(:questions) { create_list(:question, 3, user: create(:user)) }
    before do
      questions[1].update(created_at: 23.hours.ago)
      questions.last.update(created_at: 3.day.ago)
    end

    it 'should return only two questions' do
      expect(Question.new_for_the_last_day.count).to eq(2)
    end

    it 'should not contain question with invalid created date' do
      expect(Question.new_for_the_last_day).to_not be_include(questions.last)
    end
  end
end
