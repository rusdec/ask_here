module Feature
  module Question
    def create_question(params)
      visit new_question_path
      fill_in 'Title', with: params[:title]
      fill_in 'Body', with: params[:body]
      click_on 'Create Question'
    end

    def update_question(params)
      visit question_path(params[:question])
      click_question_edit_link
      within '.form-edit-question' do
        fill_in 'Title', with: params[:title]
        fill_in 'Body', with: params[:body]
        click_on 'Save'
      end
    end

    def click_question_edit_link
      within '.question-remote-links' do
        click_on 'Edit'
      end
    end

    def click_question_delete_link
      within '.question-remote-links' do
        click_on 'Delete'
      end
    end

    def question_delete_link
      ".link-delete-question"
    end
  end
end
