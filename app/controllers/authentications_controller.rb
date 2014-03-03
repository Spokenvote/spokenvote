class AuthenticationsController < Devise::SessionsController
  def create
    auth = params[auth_params]
    @new_user_saved = false

    # Try to find authentication first
    authentication = Authentication.find_by_provider_and_uid(auth[:provider], auth[:uid])
    #authentication = Authentication.find_by_provider_and_uid((auth_params.provider), (auth_params.uid))
    try_existing_user =
        if auth[:email] =~ /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
          User.find_by_email(auth[:email])
        else
          User.find_by_id(authentication.try(:user_id))
        end

    # Create user or update the user info as needed
    user = User.from_omniauth(try_existing_user.try(:id), auth)
    user.authentications.create(:provider => auth[:provider], :uid => auth[:uid], :token => auth[:token]) unless authentication
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
  params.require(:auth).permit(:provider, :uid, :user_id, :token)
end