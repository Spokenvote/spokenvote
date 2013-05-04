class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :sanitize_bad_params_from_angular # TODO: Remove when we fix angular to not send 'undefined' values for params
  around_filter :render_layout_if_html

  def sanitize_bad_params_from_angular
    params.delete_if{ |key, value| value == 'undefined' }
  end

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
