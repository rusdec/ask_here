require 'rails_helper'

RSpec.describe Answer, type: :model do
  context 'relations' do
    it { should belong_to(:question) }
    it { should belong_to(:user).with_foreign_key(:author_id) }
    it { should belong_to(:user).class_name('User') }
  end

  context 'validations' do
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:question_id) }
    it { should validate_presence_of(:author_id) }

    it do
      should validate_numericality_of(:question_id).
        only_integer
    end

    it do
      should validate_numericality_of(:author_id).
        only_integer
    end

    it do
      should validate_length_of(:body).
        is_at_least(10).is_at_most(1000)
    end
  end      
end
