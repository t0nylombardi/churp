# frozen_string_literal: true

module Api
  module V1
    class SuggestionsController < ApplicationController
      def index
        q = params[:q].to_s.strip
        return render_error("query empty") if q.blank?

        users = User
          .where("username ILIKE ?", "%#{sanitize_sql_like(q)}%")
          .order(:username)
          .limit(5)

        render json: UserSerializer.render(users)
      end
    end
  end
end
