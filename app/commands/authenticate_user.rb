class AuthenticateUser
  prepend SimpleCommand

  def initialize(email, password)
    @email = email
    @password = password
  end

  def call
    user
  end

  private

  attr_accessor :email, :password

  def user
    user = User.find_by(email: email)
    return user if user&.valid_password?(password)
    errors.add(:user_authentication, "invalid credentials")
    nil
  end
end
