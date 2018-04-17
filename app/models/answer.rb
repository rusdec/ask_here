class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, { presence: true,
                     length: { minimum: 10,
                               maximum: 1000 } }

  def not_best!
    self.best = false
    save!
  end

  def best!
    question.uncheck_best_answers
    self.best = true
    save!
  end
end
