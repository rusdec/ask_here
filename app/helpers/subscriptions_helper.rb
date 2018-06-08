module SubscriptionsHelper
  def subscribe_links(subscribable)
    if current_user
      subscription = current_user.subscriptions.find_by(subscribable: subscribable)
      link = subscription ? unfollow_link(subscription) : follow_link(subscribable)
      content_tag :div, class: 'subscribes-links' do
        concat(link)
      end
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
