class RegistrationsController < Devise::RegistrationsController

  def create
    respond_to do |format|
      format.html {
        super
      }
      format.json {
        build_resource
        if resource.save
          render json: {success: true, new_user: resource}, status: :created
          sign_up(resource_name, resource)
        else
          render success: false, json: resource.errors, status: :unprocessable_entity
        end
      }
    end
  end

  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

  def update
    @user = User.find(current_user.id)

    successfully_updated = if needs_password?(@user, params)
      @user.update_with_password(params[:user])
    else
      params[:user].delete(:current_password)

      @user.update_without_password(params[:user])
    end

    if successfully_updated
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end

  private

  def needs_password?(user, params)
    user.email != params[:user][:email] ||
      !params[:user][:password].empty?
  end
end