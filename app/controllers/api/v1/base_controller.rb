# frozen_string_literal: true

module Api
  module V1
    class BaseController < ActionController::API
      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      before_action :authenticate_api_user!

      attr_reader :current_user

      private

      def authenticate_api_user!
        token = request.headers["Authorization"]&.split&.last
        return render_unauthorized unless token

        result = Authentication::AuthenticateToken.call(token:)
        return render_unauthorized unless result.success?

        @current_user = result.value
      end

      def render_error(record)
        render json: {
          errors: record.errors.full_messages
        }, status: :unprocessable_content
      end

      def render_unauthorized
        render json: { error: "Unauthorized" }, status: :unauthorized
      end

      def not_found
        render json: { error: "Not Found" }, status: :not_found
      end

      def pagy_metadata(pagy)
        {
          page: pagy.page,
          pages: pagy.pages,
          count: pagy.count
        }
      end
    end
  end
end
