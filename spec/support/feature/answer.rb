module Feature
  module Answer
    def create_answer(params)
      within '#new_answer' do
        fill_in 'Body', with: params[:body]
        yield if block_given?
        click_on 'Create Answer'
      end
    end

    def answer_container(answer)
      ".answer[data-id='#{answer.id}']"
    end

    def update_answer(params)
      within answer_container(params[:answer]) do
        click_on 'Edit'
        fill_in 'Body', with: params[:body]
        click_on 'Save'
      end
    end

    def click_edit_answer_link(answer)
      within answer_container(answer) do
        click_on 'Edit'
      end
    end

    def click_delete_answer_link(answer)
      within answer_container(answer) do
        click_on 'Delete'
      end
    end

    def click_set_as_best_answer_link(answer)
      within answer_container(answer) do
        click_on 'Best answer'
      end
    end

    def click_set_as_not_best_answer_link(answer)
      within answer_container(answer) do
        click_on 'Not a Best'
      end
    end

    def best_answer_id
      '#best_answer'
    end

    def answer_edit_form(answer)
      "#{answer_container(answer)} .form-edit-answer"
    end
  end
end
