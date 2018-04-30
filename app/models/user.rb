class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy

  validates :password, length: { minimum: 5,
                                 maximum: 20 }

  def author_of?(entity)
    id == entity.user_id
  end

  def not_author_of?(entity)
    !author_of?(entity)
  end
end
