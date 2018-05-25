require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  check_authorizations

  protect_from_forgery with: :exception
  before_action :gon_user

  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
