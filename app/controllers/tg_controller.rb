class TgController < ActionController::API
  def auth_callback
    render json: params
  end
end
