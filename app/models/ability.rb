class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
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

    vote_abilities
    best_answer_abilities
  end

  def user_abilities
    alias_action :update, :destroy, to: :author_actions
    can(:author_actions, :all, user: user)

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
    alias_action :add_vote, :cancel_vote, to: :vote_actions
    can :vote_actions, [Answer, Question] do |votable|
      user.not_author_of?(votable)
    end
  end
end
