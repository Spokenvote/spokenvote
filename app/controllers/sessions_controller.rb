class SessionsController < Devise::SessionsController
  def create
    resource = warden.authenticate!(scope: resource_name, recall: 'sessions#failure')
    sign_in_and_redirect(resource_name, resource, URI(request.referrer).path)
  end

  # DELETE /resource/sign_out
  def destroy
    redirect_path = after_sign_out_path_for(resource_name)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_flashing_format?
    yield resource if block_given?

    respond_to do |format|
      format.all { head :no_content }
    end
  end

  def sign_in_and_redirect(resource_or_scope, resource=nil, referrer)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource

    if params[:user][:remember_me] && params[:user][:email]
      cookies['_spokenvote_email'] = {value: params[:user][:email], expires: 1.year.from_now}
    end

    if referrer != '/users/login'
      render json: {success: true, redirect: stored_location_for(scope) || after_sign_in_path_for(resource)}
    else
      redirect_to root_url, notice: t('devise.sessions.signed_in')
    end
  end

  def failure
    return render json: {success: false, errors: ["Login failed."]}
  end
end