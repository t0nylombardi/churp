# frozen_string_literal: true

module Authentication
  module Tokens
    class JwtDecoder
      SECRET = Rails.application.secret_key_base

      def self.decode(token)
        decoded, = JWT.decode(token, SECRET, true, algorithm: "HS256")
        decoded.with_indifferent_access
      rescue JWT::DecodeError
        nil
      end
    end
  end
end
