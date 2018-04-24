class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachements, as: :attachable,
                          inverse_of: :attachable,
                          dependent: :destroy
  belongs_to :user

  validates :body, { presence: true,
                     length: { minimum: 10,
                               maximum: 1000 } }

  validates :title, { presence: true,
                      length: { minimum: 10,
                                maximum: 30 } }

  accepts_nested_attributes_for :attachements, allow_destroy: true

  def best_answers
    answers.best_answers
  end

  def created_answers
    answers.created_answers
  end
end
