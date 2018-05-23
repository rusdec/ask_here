class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i[github twitter]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  validates :password, length: { minimum: 5,
                                 maximum: 20 }

  accepts_nested_attributes_for :authorizations, allow_destroy: true,
                                                 reject_if: :all_blank

  delegate :vote_for, to: :votes

  def author_of?(entity)
    id == entity.user_id
  end

  def not_author_of?(entity)
    !author_of?(entity)
  end

  def create_authorization(auth)
    authorizations.create!(provider: auth.provider, uid: auth.uid)
  end

  class << self
    def find_for_oauth(auth)
      authorization = Authorization.where(provider: auth.provider, uid: auth.uid).first
      return authorization.user if authorization

      user = find_by(email: auth.info.email)

      user = create_user(auth) if user.nil?

      if user.persisted?
        user.create_authorization(auth)
        user.send_confirmation_instructions if auth.with_request_email
      end

      user
    end

    def create_user(auth)
      password = Devise.friendly_token(10)
      params = { email: auth.info.email,
                 password: password,
                 password_confirmation: password }

      # when email was given via special form
      # user must confirm it
      params[:confirmed_at] = Time.now if auth.with_request_email.nil?

      User.create(params)
    end
  end
end
