require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:body) }

  it do
    should validate_length_of(:body).
      is_at_least(10).is_at_most(1000)
  end

  describe 'best unswer' do
    let(:question) { create(:user_with_question_and_best_answer).questions.last }

    it 'uncheckable' do
      best_answer = question.best_answers.last
      
      expect {
        best_answer.not_best!
      }.to change(question.best_answers, :count).by(-1)

      expect(best_answer).to_not be_best
    end

    it 'may be only one per question' do
      answer = question.answers.find_by(best: false)
      expect {
        answer.best!
      }.to_not change(question.best_answers, :count)
    end
  end
end
