require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should have_many(:attachements).dependent(:destroy) }
  it do
    should accept_nested_attributes_for(:attachements).
      allow_destroy(true)
  end
  it { should belong_to(:user) }

  it { should validate_presence_of(:body) }

  it do
    should validate_length_of(:body).
      is_at_least(10).is_at_most(1000)
  end

  describe 'best answer' do
    let(:question) { create(:user_with_question_and_best_answer).questions.last }
    let(:best_answer) { question.best_answers.last }

    describe 'when becomes not best answer' do
      it 'count of best answers decreases' do
        expect {
          best_answer.not_best!
        }.to change(question.best_answers, :count).by(-1)
      end

      it 'are not longer the best' do
        best_answer.not_best!
        expect(best_answer).to_not be_best
      end
    end

    it 'may be only one per question' do
      answer = question.answers.find_by(best: false)

      expect {
        answer.best!
      }.to_not change(question.best_answers, :count)
    end

    it 'first' do
      expect(question.answers.first).to eq(best_answer)
    end

    it 'create attachement with valid attributes' do
      answer = create(:answer,
                      user: create(:user),
                      question: question,
                      attachements_attributes: [attributes_for(:attachement)])

      expect(answer.attachements.count).to eq(1)
    end

    it 'reject attachemnet with invalid attributes' do
      answer = create(:answer,
                      user: create(:user),
                      question: question,
                      attachements_attributes: [attributes_for(:invalid_attachement)])

      expect(answer.attachements.count).to eq(0)
    end
  end
end
