require_relative 'models_helper'
require 'with_model'

RSpec.describe Subscription, type: :model do

  it_behaves_like 'userable'
  it { should belong_to(:subscribable) }

  context '.subscribed?' do
    with_model :any_subscribable do
      table do |t|
        t.integer :user_id
      end

      model do
        include Userable
      end
    end

    let(:user) { create(:user) }
    let(:subscribable) { AnySubscribable.create(user: user) }

    it 'should be true' do
      create(:subscription, user: user, subscribable: subscribable)
      expect(user.subscriptions).to be_subscribed(subscribable)
    end

    it 'should be false' do
      create(:subscription, user: create(:user), subscribable: subscribable)
      expect(user.subscriptions).to_not be_subscribed(subscribable)
    end
  end
end
