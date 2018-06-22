require_relative 'models_helper'

RSpec.describe Vote, type: :model do

  with_model :AnyVotable do
    table do |t|
      t.integer :user_id
    end

    model do
      include Votable
      belongs_to :user
    end
  end

  it_behaves_like 'userable'

  it { should belong_to(:votable).touch(:true) }

  it { should validate_presence_of(:value) }
  it { should allow_values(1, -1).for(:value) }
  it { should_not allow_values('2', '-2', 'f', '-').for(:value) }

  describe 'validate uniqueness' do
    subject { build :vote }

    it { should validate_uniqueness_of(:user_id).
           scoped_to(:votable_id, :votable_type) }
  end

  let(:user) { create(:user) }
  let(:any_votable) { AnyVotable.create(user: create(:user)) }

  it 'get vote for specific entity' do
    vote = create(:vote, votable: any_votable, user: user)

    expect(user.votes.vote_for(any_votable)).to eq(vote)
  end


  describe 'select likes by type' do
    before do
      #one like
      create(:vote, votable: any_votable, user: create(:user))
      2.times do
        #two dislike
        create(:vote, votable: any_votable, user: create(:user), value: -1)
      end
    end

    it '#likes' do
      expect(any_votable.votes.likes).to eq(1)
    end

    it '#dislikes' do
      expect(any_votable.votes.dislikes).to eq(2)
    end

    it '#rate' do
      expect(any_votable.votes.rate).to eq(-1)
    end

    it '#rating' do
      expect(any_votable.votes.rating).to eq(likes: 1, dislikes: 2, rate: -1)
    end
  end

  it '#like?' do
    create(:vote, votable: any_votable, user: user)

    expect(any_votable.votes.first).to be_like
  end

  it '#dislike?' do
    create(:vote, votable: any_votable, user: user, value: -1)

    expect(any_votable.votes.last).to be_dislike
  end

  describe '#vote!' do
    before do
      create(:vote, votable: any_votable, user: user, value: 1)
      user.votes.vote!(votable: any_votable, value: -1)
    end

    it 'delete old record' do
      expect(user.votes.likes).to eq(0)
    end
    it 'save new record' do
      expect(user.votes.dislikes).to eq(1)
    end
  end
end
