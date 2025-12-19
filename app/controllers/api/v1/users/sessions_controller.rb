# frozen_string_literal: true

module Api
  module V1
    module Users
      class SessionsController < Api::V1::BaseController
        skip_before_action :authenticate_user!, only: :create

        def create
          user = User.find_for_database_authentication(email: sign_in_params[:email])

          return invalid_login unless user&.valid_password?(sign_in_params[:password])

          sign_in(user)

          render json: {
            user: UserSerializer.new(user)
          }, status: :ok
        end

        def destroy
          sign_out(current_user)
          head :no_content
        end

        private

        def sign_in_params
          params.require(:user).permit(:email, :password)
        end

        def invalid_login
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end
    end
  end
end
