class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    User.find_each.each do |user|
      DailyMailer.digest(user)
    end
  end
end
