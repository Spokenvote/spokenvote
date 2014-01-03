class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :intercept_html_requests
  before_filter :sanitize_bad_params_from_angular # TODO: Remove when we fix angular to not send 'undefined' values for params

  after_filter  :set_csrf_cookie_for_ng

  layout :nil

  def index
    render layout: 'application', nothing: true
  end

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  private

  def verified_request?
    super || form_authenticity_token == request.headers['X_XSRF_TOKEN']
  end

  def sanitize_bad_params_from_angular
    params.delete_if { |key, value| value == 'undefined' }
  end

  def intercept_html_requests
    if !request.format.json? && !(request.path[0,6] == '/admin')
    #if !request.format.json? && !(request.path[0,6] == '/admin') && !(request.path[0,9] == '/sitemap1')
      render('layouts/application')
    end
  end

  def authenticate_admin_user!
    redirect_to new_user_session_path unless current_user.try(:is_admin?)
  end
end
