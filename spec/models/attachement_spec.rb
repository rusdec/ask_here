require 'rails_helper'

RSpec.describe Attachement, type: :model do
  it { should belong_to(:attachable) }
end
