# frozen_string_literal: true

class JsonWebToken
  SECRET_KEY = 'c025961ae42947852b7c4e115c9994512527fc8f428ae028338b78953e9a4a2c339ca03898b71e75c926b3edf680a72e736a070cb7e626d5ab9fb69978026d21'

  def self.encode(payload, exp = 7.days.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end
