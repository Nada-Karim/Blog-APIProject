class JsonWebToken
    class << self
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload,  ENV["JWT_SECRET_KEY"])
      # Rails.logger.debug("encoded token: #{ JWT.encode(payload, SECRET_KEY)}")
    end

    def decode(token)
      #  Rails.logger.debug("Decoding token: #{token}")
      body = JWT.decode(token, ENV["JWT_SECRET_KEY"])[0]
      # Rails.logger.debug("Decoded body: #{body}")
      HashWithIndifferentAccess.new body
    rescue JWT::DecodeError => e
      # Rails.logger.debug("JWT Decode Error: #{e.message}")
      nil
    end
    end
end
