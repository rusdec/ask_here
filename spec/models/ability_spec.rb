require 'rails_helper'
require "cancan/matchers"

describe Ability do
  subject(:ability) { Ability.new(user) }

  context 'Admin' do
    let(:user) { create(:user, admin: true) }
    it { should be_able_to(:manage, :all) }
  end

  context 'User' do
    let(:user) { create(:user, admin: false) }
    let(:other_user) { create(:user) }
    let(:entities) { [:question, :answer, :comment] }

    it { should be_able_to([:read, :create], :all) } 

    # question
    it { should be_able_to([:update, :destroy], create(:question, user: user), user: user) }
    it { should_not be_able_to([:update, :destroy], create(:question, user: other_user), user: user) }

    #answer
    it do
      should be_able_to([:update, :destroy], create(:answer,
                                                    question: create(:question, user: user),
                                                    user: user), user: user)
    end
    it do
      should_not be_able_to([:update, :destroy], create(:answer,
                                                        question: create(:question, user: user),
                                                        user: other_user), user: user)
    end

    #comment
    it do
      should be_able_to([:update, :destroy], create(:comment,
                                                    commentable: create(:question, user: user),
                                                    user: user), user: user)
    end
    it do
      should_not be_able_to([:update, :destroy], create(:comment,
                                                        commentable: create(:question, user: user),
                                                        user: other_user), user: user)
    end
  end

  context 'Guest' do
    let(:user) { nil }

    it { should be_able_to(:read, :all) } 
  end
end
