class Api::V1::ProfilesController < Api::V1::BaseController
  before_action :set_users, only: :index

  def me
    authorize! :read, current_resource_owner
    respond_with(current_resource_owner)
  end

  def index
    authorize! :read, @users
    respond_with(@users)
  end

  private

  def set_users
    @users = User.where.not(id: current_resource_owner)
  end
end
