module VotesHelper
  def vote_links(params)
    params[:vote] ||= current_user.votes.build(votable: params[:resource])
    build_vote_links(params[:vote], params[:resource]).html_safe
  end

  def build_vote_links(vote, resource)
    like_params = like_params_for(vote, resource)
    dislike_params = dislike_params_for(vote, resource)

    if vote.new_record?
      "#{post_vote_link(like_params)} #{vote_rating(resource)} #{post_vote_link(dislike_params)}"
    elsif vote.like?
      "#{delete_vote_link(like_params)} #{vote_rating(resource)} #{post_vote_link(dislike_params)}"
    else
      "#{post_vote_link(like_params)} #{vote_rating(resource)} #{delete_vote_link(dislike_params)}"
    end
  end

  def like_params_for(vote, resource)
    { vote: vote,
      resource: resource,
      type: 'like',
      value: 1 }
  end

  def dislike_params_for(vote, resource)
    like_params_for(vote, resource).merge(type: 'dislike', value: -1)
  end

  def delete_vote_link(params)
    vote_link(params.merge(method: :delete))
  end

  def post_vote_link(params)
    vote_link(params.merge(method: :post))
  end

  def vote_link(params)
    options = vote_link_options(params)
    options[:class] << ' red' if params[:method] == :delete
    link_to params[:type].capitalize, path_to_vote(params[:resource]), options
  end

  def vote_link_options(params)
    { remote: true,
      method: params[:method],
      class: 'vote',
      data: { format: :json,
              vote: params[:type],
              params: value_attribute(params[:value]) } }
  end

  def path_to_vote(resource)
    polymorphic_path([:vote, resource])
  end

  def vote_rating(resource)
    content_tag 'span', data: { vote: 'rate' } do
      resource.rate.to_s
    end
  end

  def vote_container_klass_name(resource)
    "vote-#{resource.class.to_s.downcase}-#{resource.id}"
  end

  def value_attribute(value)
    "vote[value]=#{value}"
  end
end
