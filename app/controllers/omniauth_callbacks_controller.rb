class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def all
    auth = request.env["omniauth.auth"]
    provider, uid, name, email, avatar_url, token  = auth.provider, auth.uid, auth.info.name, auth.info.email, auth.info.image, auth.credentials.token

    user = User.find_by_email(email)
    authentication = Authentication.find_by_provider_and_uid(provider, uid)

    if user.nil?
      user = User.new(:email => email)
      user.authentications.build(provider: provider, uid: uid, token: token)
      if user.save!
        user.create_avatar(remote_image_url: avatar_url) rescue nil  # Dont fail if we're unable to save avatar
        render json: {success: true, redirect: new_user_registration_url}
      else
        session["devise.user_attributes"] = user.attributes
        render json: {success: false, redirect: new_user_registration_url}
      end
    else

      user.authentications.create(provider: provider, uid: uid, token: token) unless authentication # Regular signed up user, allow him this omniauth signup also
      render json: {success: true, status: 'signed_in'}
      custom_sign_in_and_redirect user
    end
  end

  alias_method :twitter, :all
  alias_method :facebook, :all
  alias_method :google_oauth2, :all
  alias_method :github, :all

  private
  def custom_sign_in_and_redirect(resource)
    scope = Devise::Mapping.find_scope!(resource)
    sign_in(scope, resource, {})
    redirect_to root_path
  end
end