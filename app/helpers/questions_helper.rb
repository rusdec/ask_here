module QuestionsHelper
  def delete_question_link(question)
    if current_user&.author_of?(question) 
      link_to 'Delete Question', question_path(question), method: :delete
    end
  end
end
