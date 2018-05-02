require 'rails_helper'

RSpec.describe Attachement, type: :model do
  it { should belong_to(:attachable) }

  it 'save file name' do
    attachement = create(:attachement, attachable: create(:question,
                                                          user: create(:user)))
    expect(attachement.name).to eq('restart.txt')
  end
end
