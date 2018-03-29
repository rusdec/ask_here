require 'rails_helper'

RSpec.describe Answer, type: :model do
  context 'relations' do
    it { should belong_to(:question) }
  end

  context 'validations' do
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:question_id) }

    it do
      should validate_numericality_of(:question_id).
        only_integer
    end

    it do
      should validate_length_of(:body).
        is_at_least(10).is_at_most(1000)
    end
  end      
end
