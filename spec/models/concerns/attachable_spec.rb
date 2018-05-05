require 'rails_helper'

shared_examples_for 'attachable' do
  puts described_class.to_s
  it { should have_many(:attachements).dependent(:destroy) }
  it do
    should accept_nested_attributes_for(:attachements).
      allow_destroy(true)
  end
end
