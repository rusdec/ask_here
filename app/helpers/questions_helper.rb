module QuestionsHelper
  def question_remote_links(question)
    links = content_tag :div, class: 'container-link question-remote-links' do
              concat(link_to 'Edit', 'javascript:void(0)', class: 'link-edit-question')
              concat(' ')
              concat(link_to 'Delete',
                     question_path(question),
                     method: :delete,
                     class: 'link-delete-question',
                     remote: true)
            end
     icon = content_tag :div, class: 'container-icon' do
              concat(fa_icon 'cog', class: 'icon icon-remote-links')
            end

     content_tag :div, class: 'question-overtitle-container' do
       concat(icon)
       concat(links)
     end
  end

  def question_info(question)
    "#{question.user.email}, #{question.created_at.strftime('%d.%m.%Y')}"
  end
end
