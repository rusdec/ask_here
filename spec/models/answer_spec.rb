require_relative 'models_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'votable'
  it_behaves_like 'attachable'
  it_behaves_like 'userable'
  it_behaves_like 'commentable'
  it_behaves_like 'searchable'

  it { should belong_to(:question) }

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
        expect(best_answer).to be_not_best
      end
    end

    it 'may be only one per question' do
      answer = question.answers.find_by(best: false)
      expect{ answer.best! }.to_not change(question.best_answers, :count)
    end

    it 'first' do
      expect(question.answers.first).to eq(best_answer)
    end

    context '#send_new_answer_notification' do
      let!(:question) { create(:question, user: create(:user)) }

      it 'should send after create' do
        expect(NewAnswerNotificationJob).to receive(:perform_later)
        create(:answer, question: question, user: create(:user))
      end

      it 'should not send after update' do
        answer = create(:answer, question: question, user: create(:user))
        expect(NewAnswerNotificationJob).to_not receive(:perform_later)
        answer.update(body: 'AnyValidAnswerBodyText')
      end
    end
  end
end
