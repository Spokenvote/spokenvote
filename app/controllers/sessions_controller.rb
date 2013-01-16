class SessionsController < Devise::SessionsController
  
  def create
    resource = warden.authenticate!(scope: resource_name, recall: 'sessions#failure')
    sign_in_and_redirect(resource_name, resource, URI(request.referrer).path)
  end
  
  def sign_in_and_redirect(resource_or_scope, resource=nil, referrer)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource
    if referrer != '/users/login'
      render json: {success: true, redirect: stored_location_for(scope) || after_sign_in_path_for(resource)}
    end
  end

  def failure
    return render json: {success: false, errors: ["Login failed."]}
  end
end