class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :subscribable, polymorphic: true

  def self.subscribed?(subscribable)
    find_by(subscribable: subscribable) ? true : false
  end

  def self.subscribe!(subscribable)
    Subscription.create(user: subscribable.user, subscribable: subscribable)
  end
end
