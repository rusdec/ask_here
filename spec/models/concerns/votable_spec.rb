require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }
  it do
    should accept_nested_attributes_for(:votes).
      allow_destroy(true)
  end

  it { should delegate_method(:likes).to(:votes) }
  it { should delegate_method(:dislikes).to(:votes) }
end
