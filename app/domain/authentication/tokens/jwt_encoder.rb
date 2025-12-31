# frozen_string_literal: true

module Authentication
  module Tokens
    class JwtEncoder
      SECRET = Rails.application.secret_key_base

      def self.encode(payload, exp: 24.hours.from_now)
        payload[:exp] = exp.to_i
        JWT.encode(payload, SECRET, "HS256")
      end
    end
  end
end
