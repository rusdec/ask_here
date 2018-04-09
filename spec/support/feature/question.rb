module Feature
  module Question
    def create_question(params)
      visit new_question_path
      fill_in 'Title', with: params[:title]
      fill_in 'Body', with: params[:body]
      click_on 'Create Question'
    end
  end
end
