module Feature
  module Question
    def create_question(params)
      visit new_question_path
      fill_in 'Title', with: params[:title]
      fill_in 'Body', with: params[:body]
      yield if block_given? 
      click_on 'Create Question'
    end

    def update_question(params)
      visit question_path(params[:question])
      click_on 'Edit'
      within '.form-edit-question' do
        fill_in 'Title', with: params[:title]
        fill_in 'Body', with: params[:body]
        click_on 'Save'
      end
    end
  end
end
