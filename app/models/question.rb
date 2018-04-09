class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user, foreign_key: :author_id, class_name: 'User'

  validates :body, { presence: true,
                     length: { minimum: 10,
                               maximum: 1000 } }
  validates :title, { presence: true,
                      length: { minimum: 10,
                                maximum: 30 } }

  def created_answers
    answers.where.not(id: nil)
  end
end
