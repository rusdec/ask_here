module CommentsHelper
  def comment_action_links(comment)
    content_tag :div, class: 'links' do
      concat(link_to 'Delete', comment_path(comment),
                               class: 'link-delete',
                               method: :delete,
                               remote: true,
                               format: :json)
      concat(link_to 'Edit', '#', class: 'link-edit')
    end
  end
end
