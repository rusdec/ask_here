module Feature
  module Answer
    def create_answer(params)
      visit question_path(params[:question])
      fill_in 'Body', with: params[:body]
      click_on 'Create Answer'
    end
  end
end
