# These lets votable must be declared
#   @let votable [Hash]
#     @param resource_name [String] the any resource name
#     @param resource_name_plural [String] the any plural (or not) name
#     @param resource_uri [String] the path for resource page
#     @param resource [Object] the instance of any votable class (Answer, Question, etc)
#     @param user [User] the instance of User

shared_examples_for 'votable' do
  given(:resource_name) { votable[:resource_name] }
  given(:resource_name_plural) { votable[:resource_name_plural] }

  given!(:vote) { create("#{resource_name}_vote".to_sym,
                         votable: votable[:resource],
                         user: votable[:user],
                         value: true) }

  context 'Authenticated user' do
    context 'when author of resource' do
      before do
        sign_in(votable[:user])
        visit votable[:resource_uri]
      end

      scenario 'no see vote options for a resource', js: true do
        within ".#{resource_name_plural}" do
          expect(page).to have_no_content('Like')
          expect(page).to have_no_content('Dislike')
        end
      end

      scenario 'can see vote rating of resource', js: true do
        within ".#{resource_name_plural}" do
          expect(page).to have_content('1')
        end
      end
    end

    context 'when not author of resource' do
      before do
        sign_in(create(:user))
        visit votable[:resource_uri]
      end

      context 'and vote for a resource' do
        scenario 'see vote options', js: true do
          within ".#{resource_name_plural}" do
            expect(page).to have_content('Like')
            expect(page).to have_content('Dislike')
          end
        end

        scenario 'can vote only once', js: true do
          within ".#{resource_name_plural}" do
            expect(page).to have_content('1')

            like

            expect(page).to have_content('2')
          end
        end

        scenario 'can revote', js: true do
          within ".#{resource_name_plural}" do
            expect(page).to have_content('1')

            like
            expect(page).to have_content('2')

            dislike
            expect(page).to have_content('0')
          end
        end

        scenario 'can cancel vote', js: true do
          within ".#{resource_name_plural}" do
            expect(page).to have_content('1')

            dislike
            expect(page).to have_content('0')

            dislike
            expect(page).to have_content('1')
          end
        end
      end

      scenario 'can see vote rating of resource' do
        within ".#{resource_name_plural}" do
          expect(page).to have_content('1')
        end
      end
    end
  end # context 'Authenticated user'

  context 'Unauthenticated user' do
    before { visit votable[:resource_uri] }

    scenario 'no see vote options for a resource' do
      within ".#{resource_name_plural}" do
        expect(page).to have_no_content('Like')
        expect(page).to have_no_content('Dislike')
      end
    end

    scenario 'can see vote rating of resource' do
      within ".#{resource_name_plural}" do
        expect(page).to have_content('1')
      end
    end
  end
end
