class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.find_each.each do |subscription|
      NewAnswerNotificationMailer.notify(user: subscription.user, answer: answer)
        .deliver_later
    end
  end
end
