# frozen_string_literal: true

module Api
  module V1
    class ChurpsController < Api::V1::BaseController
      before_action :authenticate_api_user!
      before_action :set_churp, only: %i[show update destroy]

      def index
        churps = Churp.order(created_at: :desc)
        pagy, records = pagy(churps, items: 15)

        render json: {
          data: serialize(records),
          meta: pagy_metadata(pagy)
        }
      end

      def show
        render json: serialize(@churp)
      end

      def create
        churp = current_user.churps.new(churp_params)

        if churp.save
          render json: serialize(churp), status: :created
        else
          render_error(churp)
        end
      end

      def update
        if @churp.update(churp_params)
          render json: serialize(@churp)
        else
          render_error(@churp)
        end
      end

      def destroy
        @churp.destroy!
        head :no_content
      end

      private

      def set_churp
        @churp = Churp.find(params[:id])
      end

      def churp_params
        params.require(:churp).permit(:body)
      end

      def serialize(records)
        ChurpSerializer.new(records).serializable_hash
      end
    end
  end
end
