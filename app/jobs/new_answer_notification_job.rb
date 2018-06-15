class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.find_each.each do |subscription|
      next if  subscription.user.author_of?(answer.question) &&  subscription.user.author_of?(answer)
      next if  subscription.user.author_of?(answer)
      
      NewAnswerNotificationMailer.notify(
        user: subscription.user, answer: answer
      ).deliver_now
    end
  end
end
