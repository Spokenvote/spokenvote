class ApplicationController < ActionController::Base
  protect_from_forgery
  around_filter :render_layout_if_html

  def render_layout_if_html
    if request.format.json?
      yield
    else
      render layout: 'application', nothing: true
    end
  end

  def authenticate_admin_user!
    redirect_to new_user_session_path unless current_user.try(:is_admin?)
  end
end
