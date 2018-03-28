require 'rails_helper'

RSpec.describe Question, type: :model do
  context 'relations' do
    it { should have_many(:answers).dependent(:destroy) }
  end

  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }

    it do
      should validate_length_of(:title).
        is_at_least(10).is_at_most(30)
    end
    it do
      should validate_length_of(:body).
        is_at_least(10).is_at_most(1000)
    end
  end
end
