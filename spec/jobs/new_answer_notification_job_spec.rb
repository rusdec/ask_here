require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  describe '.send_new_answer_notification' do
    let(:user) { create(:user) }
    let!(:question) { create(:question_with_answers, user: user) }  
    let(:answer) { question.answers.last }
    let(:users) { create_list(:user, 2) }

    it 'send new answer notification to all subscribed users' do
      # subscribe users
      users.each { |user| create(:subscription, subscribable: question, user: user) }

      users.each do |user|
        expect(NewAnswerNotificationMailer).to receive(:notify)
                                                 .with(user: user, answer: answer)
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
    end
  end
end
