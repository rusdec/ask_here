module CommentsHelper
  def comment_action_links(comment)
    content_tag :div, class: 'links' do
      concat(link_to 'Delete', comment_path(comment),
                               class: 'link-delete',
                               method: :delete,
                               remote: true,
                               format: :json)
      concat(link_to 'Edit', 'javascript:void(0)', class: 'link-edit')
    end
  end

  def post_comment_button(params = { form: '', resource: {} })
    params[:form].submit 'Post Your Comment',
                class: 'btn button-access button-new-comment mr-3',
                data: comment_link_dataset(params[:resource])
  end

  def new_comment_link(resource)
    link_to 'Post your comment',
            'javascript:void(0)',
            class: 'link-new-comment small',
            data: comment_link_dataset(resource)
  end

  def cancel_new_comment_link(resource)
    link_to 'Cancel',
            'javascript:void(0)',
            class: 'btn button-decline link-cancel-new-comment',
            data: comment_link_dataset(resource)
  end

  def comment_link_dataset(resource)
    { commentable_class: resource.class.to_s.underscore,
      commentable_id: resource.id }
  end

  def comment_data(comment)
    tag.p "#{comment.body} - #{comment.user.email}, #{comment.created_at.strftime('%d.%m.%Y')}"
  end
end
