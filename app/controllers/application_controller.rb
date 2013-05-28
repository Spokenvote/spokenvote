class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :intercept_html_requests
  before_filter :sanitize_bad_params_from_angular # TODO: Remove when we fix angular to not send 'undefined' values for params

  layout :nil

  def index
    render layout: 'application', nothing: true
  end

  private

  def sanitize_bad_params_from_angular
    params.delete_if { |key, value| value == 'undefined' }
  end

  def intercept_html_requests
    if !request.format.json? && !request.path == '/admin'
      render('layouts/application')
    end
  end

  def authenticate_admin_user!
    redirect_to new_user_session_path unless current_user.try(:is_admin?)
  end
end
