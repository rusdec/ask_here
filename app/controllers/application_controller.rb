require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  check_authorization :unless => :devise_controller?

  protect_from_forgery with: :exception
  before_action :gon_user

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to root_path
  end

  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
