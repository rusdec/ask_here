class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, touch: true
  include Userable

  default_scope { order(:id) }
  validates :body, presence: true,
                   length: { minimum: 10,
                             maximum: 1000 }
end
