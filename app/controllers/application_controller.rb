require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  check_authorization :unless => :devise_controller?

  protect_from_forgery with: :exception
  before_action :gon_user

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html do
        flash[:alert] = exception.message
        redirect_to root_path
      end

      format.json do
        render json: { status: false, errors: [exception.message] }
      end

      format.js do
        render js: exception.message, status: :forbidden
      end
    end
  end

  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
