require 'rails_helper'

feature 'User view questions', %q{
  As user
  I can view all questions
  so that I can detail view interesting for me
} do

  before { create_list(:question, 3) }

  scenario 'User view questions' do
    visit questions_path
    save_and_open_page
    expect(page).to have_content('ValidTitle')
  end
end
