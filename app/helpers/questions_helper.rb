module QuestionsHelper
  def question_remote_links(question)
    content_tag :div, class: 'question-remote-links' do
      concat(link_to 'Edit', '#', class: 'link-edit-question')
      concat(link_to 'Delete',
             question_path(question),
             method: :delete,
             class: 'link-delete-question',
             remote: true)
    end
  end

  def extract_identifier(form_element)
    form_element.object.file.identifier
  end
end
