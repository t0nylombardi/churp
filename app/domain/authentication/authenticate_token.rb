# frozen_string_literal: true

module Authentication
  class AuthenticateToken < Orchestrator
    def initialize(token:)
      @token = token
    end

    def execute
      return failure(:invalid_token) unless payload
      return failure(:token_expired) if expired?(payload)
      return failure(:user_not_found) unless user

      success(user)
    end

    private

    attr_reader :token

    def payload
      @payload ||= Tokens::JwtDecoder.decode(token)
    end

    def user
      @user ||= User.find_by(id: payload[:user_id])
    end

    def expired?(payload)
      Time.zone.at(payload[:exp]) < Time.current unless Rails.env.development?
    end
  end
end
