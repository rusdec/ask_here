module Feature
  module Comment
    def add_comment(params)
      within params[:context] do
        # todo: попробовать '.question #new-comment' и один within
        within '.new-comment' do
          fill_in 'Body', with: params[:body]
          click_on 'Create Comment'
        end
      end
    end
  end
end
