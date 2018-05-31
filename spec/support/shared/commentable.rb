# These lets commentable must be declared
#   @let commentable [Hash]
#     @param resource_name [String] the any resource name
#     @param resource_name_plural [String] the any plural (or not) name
#     @param resource_uri [String] the path for resource page
#     @param resource [Object] the instance of any commentale class (Answer, Question, etc)

shared_examples_for 'commentable' do
  given(:resource_name) { commentable[:resource_name] }
  given(:resource_name_plural) { commentable[:resource_name_plural] }

  describe 'Create comment' do
    context 'when authenticated user' do
      before do
        sign_in(create(:user))
        visit commentable[:resource_uri]
      end

      scenario 'can add comment with valid data', js: true do
        comment_attributes = attributes_for(:comment)
        add_comment(comment_attributes.merge(context: ".#{resource_name_plural}"))

        expect(page).to have_content(comment_attributes[:body])
      end

      scenario 'can\'t add comment with invalid data', js: true do
        add_comment(attributes_for(:invalid_comment).merge(context: ".#{resource_name_plural}"))

        within ".#{resource_name_plural} .new-comment" do
          expect(page).to have_content('Body can\'t be blank')
          expect(page).to have_content('Body is too short (minimum is 10 characters)')
        end
      end
    end # context 'when authenticated user'

    context 'multiple sessions' do
      let(:comment_attributes) { attributes_for(:comment) }

      scenario 'comment appears on another user\'s page under it resource', js: true do
        Capybara.using_session('guest') do
          visit commentable[:resource_uri]
        end

        Capybara.using_session('user') do
          sign_in(create(:user))
          visit commentable[:resource_uri]
          add_comment(comment_attributes.merge(context: ".#{resource_name_plural}"))
        end

        Capybara.using_session('guest') do
          within commentable[:resource_container] do
            expect(page).to have_content(comment_attributes[:body])
          end
        end
      end

      scenario 'another user no see Edit option for comment', js: true do
        Capybara.using_session('guest') do
          visit commentable[:resource_uri]
        end

        Capybara.using_session('user') do
          sign_in(create(:user))
          visit commentable[:resource_uri]
          add_comment(comment_attributes.merge(context: ".#{resource_name_plural}"))
        end

        Capybara.using_session('guest') do
          within commentable[:resource_container] do
            expect(page).to_not have_content('Edit')
          end
        end
      end
    end # context 'multiple sessions'

    context 'when unauthenticated user' do
      scenario 'can\'t create comment' do
        visit commentable[:resource_uri]
        
        expect(page).to have_no_content('Add comment')
      end
    end
  end # describe 'Create comment'

  describe 'Update comment' do
    given(:comment_author) { create(:user) }
    given(:new_body) { 'NewValidCommentBodyText' }
    given!(:comment) do
      create(:comment, user: comment_author, commentable: commentable[:resource])
    end

    context 'when authenticated user' do
      context 'when author of comment' do
        before do
          sign_in(comment_author)
          visit commentable[:resource_uri]
        end

        scenario 'can update comment with valid data', js: true do
          update_comment(context: comment_container(comment), body: new_body)

          expect(page).to have_content(new_body)
        end

        scenario 'can\'t update comment with invalid data', js: true do
          update_comment(context: comment_container(comment), body: nil)

          within comment_container(comment) do
            expect(page).to have_content('Body can\'t be blank')
            expect(page).to have_content('Body is too short (minimum is 10 characters)')
          end
        end
      end

      context 'when not author of comment' do
        before do
          sign_in(create(:user))
          visit commentable[:resource_uri]
        end

        scenario 'no see Edit option for comment', js: true do
          within(comment_container(comment)) do
            expect(page).to_not have_content('Edit')
          end
        end
      end
    end # context 'when authenticated user'

    context 'multiple sessions' do
      scenario 'comment update on another user\'s page under it resource', js: true do
        Capybara.using_session('guest') do
          visit commentable[:resource_uri]
        end

        Capybara.using_session('user') do
          sign_in(comment_author)
          visit commentable[:resource_uri]
          update_comment(context: comment_container(comment), body: new_body)
        end

        Capybara.using_session('guest') do
          within commentable[:resource_container] do
            expect(page).to have_content(new_body)
          end
        end
      end

      scenario 'another user no see Edit option for comment', js: true do
        Capybara.using_session('guest') do
          visit commentable[:resource_uri]
        end

        Capybara.using_session('user') do
          sign_in(comment_author)
          visit commentable[:resource_uri]
          update_comment(context: comment_container(comment), body: new_body)
        end

        Capybara.using_session('guest') do
          within commentable[:resource_container] do
            expect(page).to_not have_content('Edit')
          end
        end
      end
    end # context 'multiple sessions'

    context 'when unauthenticated user' do
      scenario 'no see Edit option' do
        visit commentable[:resource_uri]
        expect(page).to have_no_content('Edit')
      end
    end
  end # describe 'Update comment'
end
