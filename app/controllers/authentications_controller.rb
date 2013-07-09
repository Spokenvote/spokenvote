class AuthenticationsController < Devise::SessionsController

  def create
    auth = params[:auth]
    @new_user_saved = false

    # Try to find authentication first
    authentication = Authentication.find_by_provider_and_uid(auth[:provider], auth[:uid])
    try_existing_user = User.find_by_email(auth[:email]) || User.find_by_id(authentication.user_id)
    existing_user_id = try_existing_user.id unless try_existing_user.nil?

    # Create user or update the user info as needed
    user = User.from_omniauth(existing_user_id, auth)
    user.authentications.create(:provider => auth[:provider], :uid => auth[:uid], :token => auth[:token]) if !authentication
    omniauth_sign_in user
  end

  private
  def omniauth_sign_in(resource)
    scope = Devise::Mapping.find_scope!(resource)
    sign_in(scope, resource, {})
    render json: {success: true, status: 'You are signed in.', new_user_saved: @new_user_saved}
  end

end