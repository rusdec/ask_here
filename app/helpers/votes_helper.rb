module VotesHelper
  def vote_forms(params)
    params[:vote] ||= current_user.votes.build(votable: params[:resource])
    get_forms(params[:vote], params[:resource]).html_safe
  end

  def get_forms(vote, resource)
    like_params = like_params_for(vote, resource)
    dislike_params = dislike_params_for(vote, resource)

    if vote.new_record?
      "#{post_vote_link(like_params)} #{vote_rating(resource)} #{post_vote_link(dislike_params)}"
    elsif vote.value?
      "#{delete_vote_link(like_params)} #{vote_rating(resource)} #{patch_vote_link(dislike_params)}"
    else
      "#{patch_vote_link(like_params)} #{vote_rating(resource)} #{delete_vote_link(dislike_params)}"
    end
  end

  def like_params_for(vote, resource)
    { vote: vote,
      resource: resource,
      type: 'like',
      value: true }
  end

  def dislike_params_for(vote, resource)
    like_params_for(vote, resource).merge(type: 'dislike', value: false)
  end

  def delete_vote_link(params)
    vote_link(params.merge(method: :delete))
  end

  def patch_vote_link(params)
    vote_link(params.merge(method: :patch))
  end

  def post_vote_link(params)
    vote_link(params.merge(method: :post))
  end

  def vote_link(params)
    options = vote_link_options(params)
    options.merge!(class: 'red') if params[:method] == :delete

    link_to params[:type].capitalize, path_to_vote(params[:resource]), options
  end

  def vote_link_options(params)
    { remote: true,
      method: params[:method],
      data: { format: :json,
              vote: params[:type],
              params: value_attribute(params[:value]) } }
  end

  def path_to_vote(resource)
    polymorphic_path([:vote, resource])
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
