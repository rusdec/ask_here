module Feature
  module Comment
    def add_comment(params)
      within "#{params[:context]}" do
        click_on '.link-new-comment'
        within '.new-comment' do
          fill_in 'Body', with: params[:body]
          click_on 'Create Comment'
        end
      end
    end

    def update_comment(params)
      within params[:context] do
        click_on 'Edit'
        fill_in 'Body', with: params[:body]
        click_on 'Update Comment'
      end
    end

    def comment_container(comment)
      ".comment[data-id='#{comment.id}']"
    end
  end
end
