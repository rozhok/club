class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = Current.user
  end
end
