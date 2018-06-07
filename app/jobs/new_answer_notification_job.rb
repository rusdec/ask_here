class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.find_each.each do |subscription|
      if subscription.user.not_author_of?(answer.question)
        NewAnswerNotificationMailer.notify(user: subscription.user, answer: answer)
      end
    end
  end
end
