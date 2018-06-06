class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subscribable, only: :create
  before_action :set_subscription, only: :destroy
  authorize_resource

  include JsonResponsed

  def create
    @subscription = current_user.subscriptions.create(subscribable: @subscribable)
    json_response_by_result
  end

  def destroy
    @subscription.destroy
    json_response_by_result
  end

  private

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def set_subscribable
    @subscribable = subscribable_klass.find(params[subscribable_id_param])
  end

  def subscribable_klass
    subscribable_id_param[0...-3].classify.constantize
  end

  def subscribable_id_param
    params.keys.select { |key| key[-3..-1] == '_id' }[0]
  end
end
