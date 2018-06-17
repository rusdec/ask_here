require_relative '../features_helper'

feature 'User can search data from any page', %q{
  As user
  I can search data from any page
  so that I can find needed data more fastest
} do

  context 'All users' do
    let(:user) { create(:user) }
    let!(:questions) { create_list(:question_with_answers, 2, user: user) }
    before do
      index
      visit search_path
    end

    scenario 'see only search input field in header' do
      within 'header' do
        expect(page).to have_button('Find')

        expect(page).to_not have_content('Context')
        expect(page).to_not have_content('Per page')
      end
    end

    scenario 'find by all', js: true do
      within 'header' do
        fill_in 'query', with: user.email
        click_on 'Find'
      end
      expect(current_path).to eq(search_path)

      questions.each do |question|
        expect(page).to have_link(question.title)
        expect(page).to have_content(question.body)

        question.answers.each do |answer|
          expect(page).to have_content(answer.body.truncate(100))
        end
      end

    end
  end
end
