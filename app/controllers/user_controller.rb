class UserController < ApplicationController
  skip_before_action :authenticate_request, only: [ :login, :signup ]

  def signup
    user = User.new(user_params)
    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by_email(params[:email])
    if user && user.valid_password?(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def test
    render json: {
          message: "You have passed"
        }
  end

  private

  def user_params
    params.permit(:name, :email, :password, :image)
  end
end
