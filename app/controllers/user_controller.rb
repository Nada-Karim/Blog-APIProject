class UserController < ApplicationController
  before_action :authenticate_request, except: [ :login, :signup ]

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
    command = AuthenticateUser.call(params[:email], params[:password])

    if command.success?
       render json: { token: JsonWebToken.encode(user_id: command.result.id) }, status: :ok
    else
      render json: { error: command.errors.full_messages }, status: :unauthorized
    end
  end

  def test
    render json: { message: "You have passed authentication", user: @current_user }
  end

  def testOne
    token = JsonWebToken.encode(user_id: 1)
    decoded_token = JsonWebToken.decode(token)
    render json: { token: decoded_token }
    @current_user = User.find(decoded_token[:user_id])
    # render json: { user: @current_user }
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :image)
  end
end
