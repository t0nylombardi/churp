# frozen_string_literal: true

module Api
  module V1
    class SuggestionsController < Api::V1::BaseController
      def index
        query = params[:q].to_s.strip
        if query.blank?
          render json: { error: "Query cannot be blank" }, status: :unprocessable_content
          return
        end

        users = User
          .where("username ILIKE ?", "%#{ActiveRecord::Base.sanitize_sql_like(query)}%")
          .order(:username)
          .limit(5)

        render json: UserSerializer.new(users).serializable_hash
      end
    end
  end
end
