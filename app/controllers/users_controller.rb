class UsersController < ApplicationController
  def show
    if params[:id].present?
      @user = User.find(params[:id])
    else
      @user = Current.user
    end
  end

  def edit
    @user = Current.user
  end

  def update
    @user = Current.user
    if @user.update(user_params)
      redirect_to profile_path
    else
      render :edit, status: :unprocessable_content
    end
  end

  def user_params
    params.expect!(user: [:username, :name, :title, :company, :location, :contacts, :avatar])
  end
end
