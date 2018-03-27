class Question < ApplicationRecord
  validates :body, { presence: true,
                     length: { minimum: 10,
                               maximum: 1000 } }
  validates :title, { presence: true,
                      length: { minimum: 10,
                                maximum: 30 } }

  has_many :answers
end
