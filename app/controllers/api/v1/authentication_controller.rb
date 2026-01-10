# frozen_string_literal: true

module Api
  module V1
    class AuthenticationController < BaseController
      skip_before_action :authenticate_api_user!, only: %i[register login]

      def register
        user = Authentication::Commands::RegisterUser.call(
          username: register_params[:username],
          email: register_params[:email],
          password: register_params[:password]
        )

        return render_registration_failed(user) unless user.success?
        render json: user.value, status: :created
      end

      def login
        result = Authentication::Commands::LoginUser.call(
          email: login_params[:email],
          password: login_params[:password]
        )

        return head :unauthorized unless result.success?

        render json: { token: result.value }, status: :ok
      end

      def login_params
        params.permit(:email, :password)
      end

      def register_params
        params.permit(:email, :password, :username)
      end

      def render_registration_failed(user)
        Rails.logger.info("Registration failed: #{user.error}")
        render json: {
          error: "Registration failed",
          details: user.error
        }, status: :unprocessable_content
      end
    end
  end
end
