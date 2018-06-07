require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  describe '.send_new_answer_notification' do
    let!(:question) { create(:question_with_answers, user: create(:user)) }  
    let(:answer) { question.answers.last }
    let(:users) { create_list(:user, 2) }

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

    it 'not send new answer notification to unsubscribed users' do
      users.each do |user|
        expect(NewAnswerNotificationMailer).to_not receive(:notify)
      end
      NewAnswerNotificationJob.perform_now(answer)
    end
  end
end
