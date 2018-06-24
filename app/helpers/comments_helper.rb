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

  def new_comment_link(resource)
    link_to 'Post your comment',
            'javascript:void(0)',
            class: 'link-new-comment small',
            data: { commentable_class: resource.class.to_s.underscore,
                    commentable_id: resource.id }
  end

  def cancel_new_comment_link(resource)
    link_to 'Cancel',
            'javascript:void(0)',
            class: 'btn button-decline link-cancel-new-comment',
            data: { commentable_class: resource.class.to_s.underscore,
                    commentable_id: resource.id }
  end
end
