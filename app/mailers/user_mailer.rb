class UserMailer < ApplicationMailer
  def magic_link
    user = params[:user]
    @magic_link_url = magic_link_url(token: user.generate_token_for(:magic_link))
    if Rails.env.development?
      Rails.logger.info(@magic_link_url)
    end

    mail(to: user.email, subject: "Вхід до Ріжок Клубу")
  end
end
