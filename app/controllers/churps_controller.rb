# frozen_string_literal: true

class ChurpsController < ApplicationController
  include Pagy::Method

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_churp, only: %i[show update destroy like rechurp]

  def index
    @pagy, @churps = pagy(Churp.order(created_at: :desc), items: 15)
    @churp = current_user.churps.new

    render "scrollable_list" if params[:page]
  end

  def show
    @user = User.friendly.find(params[:slug])
    @comment = current_user.comments.new
    @comments = @churp.comments.recent_comments
  end

  def new
    @churp = current_user.churps.build
  end

  def create
    service = Churps::CreateService.call(user: current_user, params: churp_params)

    if service.success?
      redirect_to(root_path, notice: t("churps.create.success", default: "Churp was successfully created."))
    else
      redirect_back_or_to(
        root_path, alert: t("churps.create.failure", default: "Could not churp.")
      )
    end
  end

  def update
    if @churp.update(churp_params)
      redirect_to @churp, notice: t("churps.update.success", default: "Churp updated successfully.")
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @churp.destroy
    redirect_to churps_url, notice: t("churps.destroy.success", default: "Churp deleted.")
  end

  def like
    Churps::LikeService.call(user: current_user, churp: @churp)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "like_#{@churp.id}",
          partial: "churps/shared/likes",
          locals: { churp: @churp }
        )
      end
      format.html { redirect_to churps_path }
    end
  end

  def rechurp
    service = Churps::RechurpService.call(user: current_user, original_churp: @churp)

    if service.success?
      redirect_to churps_path, notice: t("churps.rechurp.success", default: "Rechurp successful.")
    else
      redirect_to churps_path, alert: t("churps.rechurp.failure", default: "Could not rechurp.")
    end
  end

  private

  def set_churp
    @churp = Churp.find(params[:id])
  end

  def churp_params
    params[:churp]&.delete(:submit)
    params.require(:churp).permit(:content, :churp_id, :churp_pic)
  end
end
