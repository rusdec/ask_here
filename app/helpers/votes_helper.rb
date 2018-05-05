module VotesHelper
  def vote_forms(params)
    params[:vote] ||= current_user.votes.build(votable: params[:resource])
    get_forms(params[:vote], params[:resource]).html_safe
  end

  def get_forms(vote, resource)
    like_params = like_params_for(vote, resource)
    dislike_params = dislike_params_for(vote, resource)

    if vote.new_record?
      "#{post_form(like_params)} #{vote_rating(resource)} #{post_form(dislike_params)}"
    elsif vote.value?
      "#{delete_form(like_params)} #{vote_rating(resource)} #{patch_form(dislike_params)}"
    else
      "#{patch_form(like_params)} #{vote_rating(resource)} #{delete_form(dislike_params)}"
    end
  end

  def like_params_for(vote, resource)
    { vote: vote,
      resource: resource,
      button_text: like_button_text,
      type: 'like',
      value: true }
  end

  def dislike_params_for(vote, resource)
    { vote: vote,
      resource: resource,
      button_text: dislike_button_text,
      type: 'dislike',
      value: false }
  end

  def delete_form(params)
    link_to params[:button_text],
            path_to_vote(params[:resource]),
            delete_options.merge({ class: 'red',
                                   data: { format: :json,
                                           vote: params[:type],
                                           params: "vote[value]=#{params[:value]}" } })
  end

  def patch_form(params)
    link_to params[:button_text],
            path_to_vote(params[:resource]),
            patch_options.merge({ data: { format: :json,
                                          vote: params[:type],
                                          params: "vote[value]=#{params[:value]}" } })
  end

  def post_form(params)
    link_to params[:button_text],
            path_to_vote(params[:resource]),
            post_options.merge({ data: { format: :json,
                                         vote: params[:type],
                                         params: "vote[value]=#{params[:value]}" } })
  end

  def path_to_vote(resource)
    polymorphic_path([:vote, resource])
  end

  def patch_options(options = {})
    { remote: true, method: :patch, data: { format: :json } }
  end

  def delete_options(options = {})
    { remote: true, method: :delete, data: { format: :json } }
  end

  def post_options(options = {})
    { remote: true, method: :post, data: { format: :json } }
  end

  def vote_rating(resource)
    content_tag 'span', data: { vote: 'rate' } do
      (resource.likes.count - resource.dislikes.count).to_s
    end
  end

  def like_button_text
    'Like'
  end

  def dislike_button_text
    'Dislike'
  end

  def vote_container_klass_name(resource)
    "vote-#{resource.class.to_s.downcase}-#{resource.id}"
  end
end
