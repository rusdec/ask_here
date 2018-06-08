# Let subscribable must be declared
#   @let subscribable [Hash]
#     @param uri [String] the path for resource page
#     @param resource [Object] the instance of any subscribable class

shared_examples_for 'subscribable' do
  given(:user) { subscribable[:resource].user }
  
  context 'Authenticated user' do
    context 'when author of subscribable' do
      before do
        sign_in(user)
        visit subscribable[:uri]
      end

      scenario 'can unsubscribe', js: true do
        click_link('unfollow')
        expect(page).to_not have_link('unfollow')
        expect(page).to have_link('follow')
      end
    end

    context 'when not author of subscribable' do
      let(:not_author) { create(:user) }
      before { sign_in(not_author) }

      context 'and can subscribe' do
        before { visit subscribable[:uri] }

        scenario 'link change to unfollow link', js: true do
          click_link('follow')
          expect(page).to_not have_link(text: /^follow$/)
          expect(page).to have_link(text: /^unfollow$/)
        end

        scenario 'see unfollow link when reload page', js: true do
          click_link('follow')
          visit subscribable[:uri]
          expect(page).to_not have_link(text: /^follow$/)
          expect(page).to have_link(text: /^unfollow$/)
        end
      end

      context 'and can unsubscribe' do
        before do
          create(:subscription, subscribable: subscribable[:resource], user: not_author)
          visit subscribable[:uri]
        end

        scenario 'link change to follow link', js: true do
          click_link('unfollow')
          expect(page).to_not have_link(text: /^unfollow$/)
          expect(page).to have_link(text: /^follow$/)
        end

        scenario 'see follow link when reload page', js: true do
          click_link('unfollow')
          visit subscribable[:uri]
          expect(page).to_not have_link(text: /^unfollow$/)
          expect(page).to have_link(text: /^follow$/)
        end
      end
    end
  end

  context 'Unauthenticated user' do
    before { visit subscribable[:uri] }

    scenario 'no see subscribes links' do
      ['follow', 'unfollow'].each do |link_name|
        expect(page).to_not have_link(link_name)
      end
    end
  end
end
