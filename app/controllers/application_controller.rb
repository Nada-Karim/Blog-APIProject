class ApplicationController < ActionController::API
  before_action :authenticate_request

  private

  def authenticate_request
    token = request.headers["Authorization"].split(" ").last
    decoded_token = JsonWebToken.decode(token)
    @current_user = User.find(decoded_token[:user_id]) if decoded_token
  rescue
    render json: { error: "Not Authorized" }, status: :unauthorized
  end
end
