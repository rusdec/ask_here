class Question < ApplicationRecord
  include Attachable
  include Votable
  include Userable
  include Commentable
  include Subscribable

  has_many :answers, dependent: :destroy

  validates :body, { presence: true,
                     length: { minimum: 10,
                               maximum: 1000 } }

  validates :title, { presence: true,
                      length: { minimum: 10,
                                maximum: 30 } }

  scope :new_for_the_last_day, ->() { where('created_at >= ?', 1.day.ago) }

  after_create :subscribe_author

  def best_answers
    answers.best_answers
  end

  def persisted_answers
    answers.persisted_answers
  end

  private

  def subscribe_author
    Subscription.subscribe!(self)
  end
end
