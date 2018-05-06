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
      type: 'like',
      value: true }
  end

  def dislike_params_for(vote, resource)
    { vote: vote,
      resource: resource,
      type: 'dislike',
      value: false }
  end

  def delete_form(params)
    link_to params[:type].capitalize,
            path_to_vote(params[:resource]),
            options_for_method(:delete).merge({ class: 'red', data: vote_link_data(params) })
  end

  def patch_form(params)
    link_to params[:type].capitalize,
            path_to_vote(params[:resource]),
            options_for_method(:patch).merge({ data: vote_link_data(params) })
  end

  def post_form(params)
    link_to params[:type].capitalize,
            path_to_vote(params[:resource]),
            options_for_method(:post).merge({ data: vote_link_data(params) })
  end

  def vote_link_data(params)
    { vote: params[:type],
      params: value_attribute(params[:value]) }
  end

  def path_to_vote(resource)
    polymorphic_path([:vote, resource])
  end

  def options_for_method(method)
    { remote: true, method: method, data: { format: :json } }
  end

  def vote_rating(resource)
    content_tag 'span', data: { vote: 'rate' } do
      (resource.likes.count - resource.dislikes.count).to_s
    end
  end

  def vote_container_klass_name(resource)
    "vote-#{resource.class.to_s.downcase}-#{resource.id}"
  end

  def value_attribute(value)
    "vote[value]=#{value}"
  end
end
