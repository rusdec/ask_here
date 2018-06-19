require_relative 'models_helper'

RSpec.describe Comment, type: :model do

  with_model :AnyCommentable do
    table do |t|
      t.integer :user_id
    end

    model do
      include Commentable
      belongs_to :user
    end
  end

  it_behaves_like 'userable'
  it_behaves_like 'searchable'

  it { should belong_to(:commentable).touch(:true) }

  it { should validate_presence_of(:body) }

  it do
    should validate_length_of(:body).
      is_at_least(10).is_at_most(1000)
  end

  let(:user) { create(:user) }
  let(:any_commentable) { AnyCommentable.create(user: create(:user)) }

  describe 'with valid data' do
    let(:comment_attributes) do
      { commentable: any_commentable, user: user }
    end

    describe 'when new comment was created' do
      it 'save in database' do
        expect{
          create(:comment, comment_attributes)
        }.to change(Comment, :count).by(1)
      end

      it 'related with own user' do
        expect{
          create(:comment, comment_attributes)
        }.to change(user.comments, :count).by(1)
      end

      it 'related with own commentable' do
        expect{
          create(:comment, comment_attributes)
        }.to change(any_commentable.comments, :count).by(1)
      end
    end
  end
end
