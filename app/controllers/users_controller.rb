class UsersController < ApplicationController
  respond_to :json

  def show
    @user = User.find(params[:id])
  end

  def currentuser
    @user = current_user
    #render 'users/show'
    render 'users/show', nothing: true
  end
end