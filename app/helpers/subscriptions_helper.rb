module SubscriptionsHelper
  def subscribe_links(subscribable)
    subscription = current_user.subscriptions.find_by(subscribable: subscribable)
    link = content_tag :div, class: 'container-link' do
             subscription ? unfollow_link(subscription) : follow_link(subscribable)
           end
    icon = content_tag :div, class: 'container-icon' do
             concat(fa_icon 'envelope', class: 'icon icon-subscription')
           end
    content_tag :div, class: 'question-overtitle-container subscribes-links' do
      concat(icon)
      concat(link)
    end
  end

  def follow_link(subscribable)
    link_to 'follow', polymorphic_path([subscribable, :subscriptions]),
            'data-id': subscribable.id,
            'class': 'follow',
            method: :post,
            remote: true
  end

  def unfollow_link(subscription)
    link_to 'unfollow', subscription_path(subscription),
            'class': 'unfollow',
            method: :delete,
            remote: true
  end
end
