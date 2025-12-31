# frozen_string_literal: true

module Api
  class ApiController < ApplicationController
    protect_from_forgery with: :null_session

    before_action :authenticate_request!

    attr_reader :current_user

    private

    def authenticate_request!
      token = request.headers["Authorization"]&.split&.last
      return unauthorized! unless token

      payload = Authentication::Tokens::Decoder.decode(token)
      return unauthorized! unless payload

      @current_user = User.find_by(id: payload[:user_id])
      unauthorized! unless @current_user
    end

    def unauthorized!
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
