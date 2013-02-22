class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :render_proper_layout

  def render_proper_layout
    if params[:bb]
      self.class.layout 'backbone_application'
      return false
    else
      self.class.layout 'application'
    end
  end

  def authenticate_admin_user!
    redirect_to new_user_session_path unless current_user.try(:is_admin?)
  end
end
