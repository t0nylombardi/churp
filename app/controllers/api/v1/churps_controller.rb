# frozen_string_literal: true

module Api
  module V1
    class ChurpsController < Api::V1::BaseController
      include Pagy::Method

      before_action :authenticate_api_user!
      before_action :set_churp, only: %i[show like rechurp]
      before_action :set_owned_churp, only: %i[update destroy]

      def index
        churps = Churp.order(created_at: :desc)
        pagy, records = pagy(churps, items: 15)

        payload = serialize(records)
        payload[:meta] = payload.fetch(:meta, {}).merge(pagy_metadata(pagy))

        render json: payload
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

      def like
        Churps::LikeService.call(
          user: current_user,
          churp: @churp
        )

        render json: serialize(@churp), status: :ok
      end

      def rechurp
        result = Churps::RechurpService.call(
          user: current_user,
          original_churp: @churp
        )

        unless result.success?
          render json: {
            error: result.errors || "Could not rechurp"
          }, status: :unprocessable_content
          return
        end

        render json: serialize(result.original_churp), status: :created
      end

      private

      def set_churp
        @churp = Churp.find(params[:id])
      end

      def set_owned_churp
        @churp = current_user.churps.find(params[:id])
      end

      def churp_params
        params.require(:churp).permit(content: {})
      end

      def serialize(records)
        ChurpSerializer.new(records).serializable_hash
      end
    end
  end
end
