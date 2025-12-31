# frozen_string_literal: true

module Api
  module V1
    class AuthenticationController < ApiController
      skip_before_action :authenticate_request!, only: %i[register login]

      def register
        user = Authentication::Commands::RegisterUser.call(
          **params.permit(:email, :password)
        )

        render json: { id: user.id }, status: :created
      end

      def login
        token = Authentication::Commands::LoginUser.call(
          **params.permit(:email, :password)
        )

        return head :unauthorized unless token

        render json: { token: token }, status: :ok
      end
    end
  end
end
