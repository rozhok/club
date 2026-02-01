class SessionsController < ApplicationController
  skip_before_action :authenticate, only: %i[new create magic_link tg_callback]

  before_action :set_session, only: :destroy

  def index
    @sessions = Current.user.sessions.order(created_at: :desc)
  end

  def new
    if Current.user.present?
      redirect_to posts_path
    end
  end

  def create
    user = User.find_by(email: params[:email])

    if user.present?
      UserMailer.with(user: user).magic_link.deliver_later
    else
      redirect_to sign_in_path(email_hint: params[:email]), alert: "Такої пошти немає"
    end
  end

  def magic_link
    user = User.find_by_token_for(:magic_link, params[:token])

    if user
      @session = user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: @session.id, httponly: true }
      if user.newcomer?
        redirect_to profile_edit_path
      else
        redirect_to root_path
      end
    else
      redirect_to sign_in_path, alert: "Посилання зіпсулось або недійсне"
    end
  end

  def destroy
    @session.destroy
    redirect_to(sessions_path, notice: "That session has been logged out")
  end

  def tg_callback
    fields = %w[auth_date first_name id last_name photo_url username]
    secret = OpenSSL::Digest::SHA256.digest(ENV.fetch("TG_TOKEN"))
    signature = fields.filter { |f| params[f] }.map { |f| "#{f}=#{params[f]}" }.join("\n")
    hashed_signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("SHA256"), secret, signature)
    if params[:hash] == hashed_signature
      user = User.find_or_create_by_tg_id(tg_params)
      @session = user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: @session.id, httponly: true }
      if user.newcomer?
        redirect_to profile_edit_path
      else
        redirect_to root_path
      end
    else
      redirect_to sign_in_path
    end
  end

  def tg_params
    params.permit(:id, :first_name, :last_name, :username, :photo_url)
  end

  private

  def set_session
    @session = Current.user.sessions.find(params[:id])
  end
end
