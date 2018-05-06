require 'rails_helper'

shared_examples_for 'attachable' do
  it { should have_many(:attachements).dependent(:destroy) }
  it do
    should accept_nested_attributes_for(:attachements).
      allow_destroy(true)
  end
end
