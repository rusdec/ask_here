require 'rails_helper'

RSpec.describe Question, type: :model do
  context 'relations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to(:user) }
  end

  context 'validations' do
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
  end

  context 'open interface' do
    let(:answers_count) { 2 }
    let(:user) { create(:user_with_question_and_answers, answers_count: answers_count) }
    let(:question) { user.questions.last }

    it 'created answers count should be equal 2' do
      question.answers.new
      expect(question.created_answers.count).to eq(answers_count)
    end
  end
end
