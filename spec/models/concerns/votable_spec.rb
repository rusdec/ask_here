require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  it { should delegate_method(:likes).to(:votes) }
  it { should delegate_method(:dislikes).to(:votes) }
  it { should delegate_method(:rate).to(:votes) }
  it { should delegate_method(:rating).to(:votes) }
end
