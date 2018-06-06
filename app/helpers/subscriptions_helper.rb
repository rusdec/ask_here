module SubscriptionsHelper
  def subscribe_links(subscribable)
    subscription = current_user.subscriptions.find_by(subscribable: subscribable)
    subscription ? unfollow_link(subscription) : follow_link(subscribable)
  end

  def follow_link(subscribable)
    link_to 'follow', polymorphic_path([subscribable, :subscriptions]),
            'data-id': subscribable.id,
            method: :post,
            remote: true
  end

  def unfollow_link(subscription)
    link_to 'unfollow', subscription_path(subscription),
            method: :delete,
            remote: true
  end
end
