class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  validates :body, { presence: true,
                     length: { minimum: 10,
                               maximum: 1000 } }
  validates :title, { presence: true,
                      length: { minimum: 10,
                                maximum: 30 } }
end
