# frozen_string_literal: true

module Api
  module V1
    class BaseController < Api::BaseController
      private

      def render_error(message, status: :unprocessable_entity)
        render json: { error: message }, status: status
      end

      def render_success(payload, status: :ok)
        render json: payload, status: status
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
