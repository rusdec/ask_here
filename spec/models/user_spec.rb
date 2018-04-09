require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }

    it { should allow_value('example@mail.ru').for(:email) }
    it do
      should_not allow_values('examplemail.ru', 'example@mail', '@mail.ru').
        for(:email)
    end

    it do
      should validate_length_of(:password).
        is_at_least(5).is_at_most(20)
    end
  end

  context 'relations' do
    it { should have_many(:questions).with_foreign_key(:author_id) }
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).with_foreign_key(:author_id) }
    it { should have_many(:answers).dependent(:destroy) }
  end
end
