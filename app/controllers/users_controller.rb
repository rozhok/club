class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = Current.user
  end

  def update
    @user = Current.user
    if @user.update(user_params)
      render :edit, status: :ok
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def user_params
    params.expect!(user: [:username, :name, :title, :company, :location, :contacts])
  end
end
