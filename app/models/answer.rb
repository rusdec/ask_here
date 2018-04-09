class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user, foreign_key: :author_id, class_name: 'User'

  validates :body, { presence: true,
                     length: { minimum: 10,
                               maximum: 1000 } }

  validates :question_id, { presence: true,
                            numericality: { only_integer: true } }

  validates :author_id, { presence: true,
                          numericality: { only_integer: true } }
end
