module QuestionsHelper
  def delete_question_element(question)
    if current_user && current_user.question_author?(question) 
      link_to 'Delete Question', question_path(question), method: :delete
    end
  end
end
