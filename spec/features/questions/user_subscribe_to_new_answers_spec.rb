require_relative '../features_helper'

feature 'User describe to question for new answers', %q{
  As user
  I can subscribe to question
  so that I can receive notifications about new replies
} do

  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'see follow link' do
      expect(page).to have_link('follow')
    end

    context 'when click follow link' do
      scenario 'link change to unfollow link' do
        click_link('follow')
        expect(page).to_not have_link('follow')
        expect(page).to have_link('unfollow')
      end

      scenario 'see unfollow link when reload page' do
        click_link('follow')
        visit question_path(question)
        expect(page).to_not have_link('follow')
        expect(page).to have_link('unfollow')
      end
    end
  end

  context 'Unauthenticated user' do
  end
end
