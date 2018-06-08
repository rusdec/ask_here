require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  describe '.send_new_answer_notification' do
    let(:user) { create(:user) }
    let(:users) { create_list(:user, 2) }
    let!(:question) { create(:question_with_answers, user: user) }  
    let(:answer) { question.answers.last }

    it 'send new answer notification to all subscribed users' do
      # subscribe users
      users.each { |user| create(:subscription, subscribable: question, user: user) }

      users.each do |user|
        expect(NewAnswerNotificationMailer).to receive(:notify)
                                                 .with(user: user, answer: answer)
                                                 .and_call_original
      end
      NewAnswerNotificationJob.perform_now(answer)
    end

    context 'not send new answer notification' do
      it 'to unsubscribed users' do
        users.each do |user|
          expect(NewAnswerNotificationMailer).to_not receive(:notify)
        end
        NewAnswerNotificationJob.perform_now(answer)
      end

      it 'to subscribed user if user replies to own question' do
        expect(NewAnswerNotificationMailer).to_not receive(:notify)
        NewAnswerNotificationJob.perform_now(answer)
      end

      it 'to subscribed user if user is author of answer' do
        user = create(:user)
        answer = create(:answer, user: user, question: question)
        create(:subscription, subscribable: question, user: user)

        expect(NewAnswerNotificationMailer).to_not receive(:notify)
        NewAnswerNotificationJob.perform_now(answer)
      end
    end
  end
end
