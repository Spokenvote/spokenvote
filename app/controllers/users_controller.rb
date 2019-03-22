class UsersController < ApplicationController
  respond_to :json

  def show
    @user = User.find(params[:id])
  end

  def currentuser
    @user = current_user
    render 'users/show'
  end

  private

  def user_params
    params.require(:user).permit(:id)
  end
end