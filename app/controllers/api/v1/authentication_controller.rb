# frozen_string_literal: true

module Api
  module V1
    class AuthenticationController < BaseController
      skip_before_action :authenticate_api_user!, only: %i[register login]

      def register
        user = Authentication::Commands::RegisterUser.call(
          email: register_params[:email],
          password: register_params[:password]
        )
        return render json: { error: "Registration failed" }, status: :unprocessable_content unless user

        render json: { id: user.id }, status: :created
      end

      def login
        token = Authentication::Commands::LoginUser.call(
          email: login_params[:email],
          password: login_params[:password]
        )

        return head :unauthorized unless token

        render json: { token: token }, status: :ok
      end

      def login_params
        params.permit(:email, :password)
      end

      def register_params
        params.permit(:email, :password)
      end
    end
  end
end
