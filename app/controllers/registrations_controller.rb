class RegistrationsController < ApplicationController
  skip_before_action :authenticate

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: user_params[:email])
    if @user.nil?
      @user = User.new(user_params)
      @user.role = "newcomer"
      @user.save
    end

    UserMailer.with(user: @user).magic_link.deliver_later
  end

  private

  def user_params
    params.permit(:email)
  end
end
