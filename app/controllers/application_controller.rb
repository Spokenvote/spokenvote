class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :intercept_html_requests
  before_action :sanitize_bad_params_from_angular # TODO: Remove when we fix angular to not send 'undefined' values for params

  after_filter  :set_csrf_cookie_for_ng

  layout "application"

  def index
    # render layout: 'application', nothing: true
  end

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  private

  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end

  def sanitize_bad_params_from_angular
    params.delete_if { |key, value| value == 'undefined' }
  end

  def intercept_html_requests
    # render('layouts/application') unless request.format.json?
  end

  def authenticate_admin_user!
    redirect_to new_user_session_path unless current_user.try(:is_admin?)
  end
end
