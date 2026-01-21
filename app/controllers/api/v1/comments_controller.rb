# frozen_string_literal: true

module Api
  module V1
    class CommentsController < Api::V1::BaseController
      include Pagy::Method

      before_action :authenticate_api_user!
      before_action :set_churp
      before_action :set_comment, only: %i[show update destroy]

      # GET /comments or /comments.json
      def index
        comments = @churp.comments.order(created_at: :desc)
        pagy, records = pagy(comments, items: 15)

        payload = serialize(records)
        payload[:meta] = payload.fetch(:meta, {}).merge(pagy_metadata(pagy))

        render json: payload
      end

      # GET /comments/1 or /comments/1.json
      def show
        render json: serialize(@comment)
      end

      # POST /comments or /comments.json
      def create
        @comment = current_user.comments.new(comment_params)

        if @comment.save
          render json: serialize(@comment), status: :created
        else
          render_error(@comment)
        end
      end

      # PATCH/PUT /comments/1 or /comments/1.json
      def update
        if @comment.update(comment_params)
          render json: serialize(@comment)
        else
          render_error(@comment)
        end
      end

      # DELETE /comments/1 or /comments/1.json
      def destroy
        @comment.destroy

        head :no_content
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_churp
        @churp = Churp.find(params[:churp_id])
      end

      def set_comment
        @comment = @churp.comments.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def comment_params
        params
          .require(:comment)
          .permit(content: {})
          .merge(churp_id: @churp.id)
      end

      def serialize(records)
        CommentSerializer.new(records).serializable_hash
      end
    end
  end
end
