# frozen_string_literal: true

module Authentication
  module Tokens
    class JwtEncoder
      SECRET = Rails.application.secret_key_base
      ALGORITHM = "HS256"

      def self.encode(payload)
        payload = payload.dup

        unless development?
          payload[:exp] = default_expiration.to_i
        end

        JWT.encode(payload, SECRET, ALGORITHM)
      end

      def self.default_expiration
        24.hours.from_now
      end

      def self.development?
        Rails.env.development?
      end

      private_class_method :default_expiration, :development?
    end
  end
end
