require 'rails_helper'
require "cancan/matchers"

describe Ability do
  subject(:ability) { Ability.new(user) }

  context 'Admin' do
    let(:user) { create(:user, admin: true) }
    it { should be_able_to(:crud, :all) }

    context 'Answer' do
      let(:answer) do
        create(:answer, question: create(:question, user: user), user: user)
      end
      let(:other_answer) do
        create(:answer,
               question: create(:question, user: create(:user)), user: create(:user))
      end

      it { should be_able_to(:best_answer_actions, answer, user: user) }
      it { should_not be_able_to(:best_answer_actions, other_answer, user: user) }
    end

    context 'Votable' do
      let(:votable) { create(:question, user: create(:user)) }
      let(:other_votable) { create(:question, user: user) }
      let(:vote) { create(:vote, votable: votable, user: user) }
      let(:other_vote) { nil }

      it { should be_able_to(:add_vote, votable, user: user) }
      it { should_not be_able_to(:add_vote, other_votable, user: user) }

      it { should be_able_to(:cancel_vote, vote, user: user) }
      it { should_not be_able_to(:cancel_vote, other_vote, user: user) }
    end
  end

  context 'User' do
    let(:user) { create(:user, admin: false) }
    let(:entities) { [:question, :answer, :comment] }

    it { should be_able_to([:read, :create], :all) } 

    context 'Question' do
      let(:question) { create(:question, user: user) }
      let(:other_question) { create(:question, user: create(:user)) }

      it { should be_able_to(:author_actions, question, user: user) }
      it { should_not be_able_to(:author_actions, other_question, user: user) }
    end

    context 'Answer' do
      let(:answer) do
        create(:answer, question: create(:question, user: user), user: user)
      end
      let(:other_answer) do
        create(:answer,
               question: create(:question, user: create(:user)), user: create(:user))
      end

      it { should be_able_to(:author_actions, answer, user: user) }
      it { should_not be_able_to(:author_actions, other_answer, user: user) }

      it { should be_able_to(:best_answer_actions, answer, user: user) }
      it { should_not be_able_to(:best_answer_actions, other_answer, user: user) }
    end

    context 'Comment' do
      let(:comment) do
        create(:comment, commentable: create(:question, user: user), user: user)
      end
      let(:other_comment) do
        create(:comment, commentable: create(:question, user: user), user: create(:user))
      end

      it { should be_able_to(:author_actions, comment, user: user) }
      it { should_not be_able_to(:author_actions, other_comment, user: user) }
    end

    context 'Votable' do
      let(:votable) { create(:question, user: create(:user)) }
      let(:other_votable) { create(:question, user: user) }
      let(:vote) { create(:vote, votable: votable, user: user) }
      let(:other_vote) { nil }

      it { should be_able_to(:add_vote, votable, user: user) }
      it { should_not be_able_to(:add_vote, other_votable, user: user) }

      it { should be_able_to(:cancel_vote, vote, user: user) }
      it { should_not be_able_to(:cancel_vote, other_vote, user: user) }
    end
  end

  context 'Guest' do
    let(:user) { nil }

    it { should be_able_to(:read, :all) } 
  end
end
