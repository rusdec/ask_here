module QuestionsHelper
  def question_remote_links(question)
    if current_user&.author_of?(question) 
      content_tag :div, class: 'question-remote-links' do
        concat(link_to 'Edit', '#', class: 'link-edit-question')
        concat(link_to 'Delete', question_path(question), method: :delete)
      end
    end
  end
end
