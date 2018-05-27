class Api::V1::ProfilesController < ApplicationController
  skip_authorization_check

  before_action :doorkeeper_authorize!

  respond_to :json

  def me
    respond_with(current_resource_owner)
  end

  def all
    respond_with(User.where.not(id: current_resource_owner))
  end

  private

  def current_resource_owner
    if doorkeeper_token
      @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id)
    end
  end
end
