class AuthenticationsController < Devise::SessionsController

  def create
    auth = params[:auth]
    p '---------'
    # Try to find authentication first
    authentication = Authentication.find_by_provider_and_uid(auth[:provider], auth[:uid])
    user = User.find_by_email(auth[:email])
    p user

    if user.nil?
      user = User.new(:email => auth['email'])
      user.authentications.build(:provider => auth[:provider], :uid => auth[:uid], :token => auth[:token])
      #user.skip_confirmation!

      if user.save!
        user.create_avatar(:remote_image_url => auth[:avatar_url]) rescue nil  # Dont fail if we're unable to save avatar
        render json: {success: true, status: 'You have been authenticated and created as new user.'}
        omniauth_sign_in(user)
      else
        #session["devise.user_attributes"] = user.attributes   # Am thinking we don't need this now.
        render json: {success: false, status: 'Failed to create you as a new user.'}
      end
    else
      # TODO: Verify that the authentication record belongs to this user only
      p '------ else -------'
      user.authentications.create(:provider => auth[:provider], :uid => auth[:uid], :token => auth[:token]) if !authentication # Regular signed up user, allow him this omniauth sign up also
      render json: {success: true, status: 'You have been authenticated.'}
      omniauth_sign_in user
    end
  end

  #alias_method :twitter, :all
  #alias_method :facebook, :all
  #alias_method :google_oauth2, :all
  #alias_method :github, :all

  private
  def omniauth_sign_in(resource)
    scope = Devise::Mapping.find_scope!(resource)
    sign_in(scope, resource, {})
    render json: {success: true, status: 'You are signed in.'}
  end

end