require 'rails_helper'

shared_examples_for 'userable' do
  it { should belong_to(:user) }
end
