require 'rails_helper'

RSpec.describe Vote, type: :model do
  it_behaves_like 'userable'

  it { should belong_to(:votable) }

  describe 'validate uniqueness' do
    subject { build :vote }

    it { should validate_uniqueness_of(:votable_id).
           scoped_to(:votable_type, :user_id) }
  end

  it 'get vote for specific entity' do
    user = create(:user)
    question = create(:question, user: create(:user))
    vote = create(:question_vote, votable: question, user: user)
    create(:question_vote, votable: question, user: create(:user))

    expect(user.votes.vote_for(question)).to eq(vote)
  end

  describe 'select likes by type' do
    let!(:question) { create(:question, user: create(:user)) }
    before do
      create(:question_vote,
             votable: create(:question, user: create(:user)),
             user: create(:user),
             value: true)
      create(:question_vote, votable: question, user: create(:user), value: true)
      2.times do
        create(:question_vote, votable: question, user: create(:user), value: false)
      end
    end

    it '#likes' do
      expect(question.votes.likes.count).to eq(1)
    end

    it '#dislikes' do
      expect(question.votes.dislikes.count).to eq(2)
    end
  end
end
