class SessionsController < Devise::SessionsController
  # DELETE /resource/sign_out
  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_flashing_format?
    yield resource if block_given?
    render json: { success: true, status: 'You are signed out.' }
  end
end


