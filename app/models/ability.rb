class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def admin_abilities
    alias_action :create, :read, :update, :destroy, to: :crud
    can(:crud, :all)

    author_abilities
    vote_abilities
    best_answer_abilities
  end

  def user_abilities
    author_abilities
    guest_abilities
    best_answer_abilities
    vote_abilities
    can(:create, :all)
  end

  def guest_abilities
    can(:read, :all)
  end

 def best_answer_abilities
    alias_action :best_answer, :not_best_answer, to: :best_answer_actions
    can :best_answer_actions, Answer do |answer|
      user.author_of?(answer.question)
    end
  end

  def vote_abilities
    can :add_vote, Votable do |votable|
      user.not_author_of?(votable)
    end
    can :cancel_vote, Vote do |vote|
      vote
    end
  end

  def author_abilities
    alias_action :update, :destroy, to: :author_actions
    can(:author_actions, :all, user: user)
  end
end
