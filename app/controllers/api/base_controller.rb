# frozen_string_literal: true

module Api
  class BaseController < ActionController::API
    include Pagy::Backend

    before_action :authenticate_user!

    rescue_from ActiveRecord::RecordNotFound, with: :not_found

    private

    def not_found(error)
      render json: {
        error: error.message
      }, status: :not_found
    end
  end
end
