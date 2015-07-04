class AuthenticationsController < Devise::SessionsController
  def create
    @new_user_saved = false
    # TODO  Code comments can be deleted.
    # Try to find authentication first
    authentication = Authentication.find_by_provider_and_uid(auth_params[:provider], auth_params[:uid] )
    try_existing_user = User.find_by_id(authentication.try(:user_id)) || User.find_by_email(auth_params[:email])

      #Code we might use if we ever auth with email again:
        #if auth_params[:email] =~ /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
        #  User.find_by_email(auth_params[:email])
        #else
        #  User.find_by_id(authentication.try(:user_id))
        #end

    # Create user or update the user info as needed
    user = User.from_omniauth(try_existing_user.try(:id), auth_params)
    user.authentications.create(provider: auth_params[:provider], uid: auth_params[:uid], token: auth_params[:token]) unless authentication
    @new_user_saved = true
    omniauth_sign_in user
  end

  private

  def omniauth_sign_in(resource)
    scope = Devise::Mapping.find_scope!(resource)
    sign_in(scope, resource, {})
    render json: { success: true, status: 'You are signed in.', new_user_saved: @new_user_saved }
  end
end

def auth_params
  params.require(:auth).permit(:provider, :uid, :name, :email, :token, :expiresIn)
end