class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  include Userable

  validates :body, presence: true,
                   length: { minimum: 10,
                             maximum: 1000 }
end
