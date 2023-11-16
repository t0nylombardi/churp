# frozen_string_literal: true

class ChurpsController < ApplicationController
  before_action :authenticate_user!, except: %i(show)
  before_action :set_churp, only: %i(show edit update destroy like rechurp)

  def index
    @pagy, @churps = pagy(Churp.order(created_at: :desc), items: 15)
    @churp = current_user.churps.new

    render 'scrollable_list' if params[:page]
  end

  # GET /churps/1
  # GET /churps/1.json
  def show
    @user = User.friendly.find(params[:slug])
    @comment = current_user.comments.new
    @comments = @churp.comments.recent_comments
  end

  # GET /churps/new
  def new
    @churp = current_user.churps.build
  end

  # GET /churps/1/edit
  def edit; end

  # POST /churps
  # POST /churps.json
  def create
    @churp = Churp.new(churp_params.merge(user: current_user))
    # binding.pry
    respond_to do |format|
      if @churp.save
        format.html { redirect_to root_path, notice: 'churp was successfully created.' }
        format.json { render :show, status: 201, location: @churp }
      else
        format.html { redirect_back fallback_location: @churp, alert: 'Could not churp' }
        format.json { render json: @churp.errors, status: 422 }
      end
    end
  end

  # PATCH/PUT /churps/1
  # PATCH/PUT /churps/1.json
  def update
    respond_to do |format|
      if @churp.update(churp_params)
        format.html { redirect_to @churp, notice: 'churp was successfully updated.' }
        format.json { render :show, status: 200, location: @churp }
      else
        format.html { render :edit }
        format.json { render json: @churp.errors, status: 422 }
      end
    end
  end

  # DELETE /churps/1
  # DELETE /churps/1.json
  def destroy
    @churp.destroy
    respond_to do |format|
      format.html { redirect_to churps_url, notice: 'churp was successfully destroyed.' }
      format.json { head 204 }
    end
  end

  def like
    current_user.likes.create(likeable: @churp)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "like_#{@churp.id}",
          partial: 'churps/shared/likes',
          locals: { churp: @churp }
        )
      end
      format.html { redirect_to churps_path }
    end
  end

  def rechurp
    @rechurp = current_user.churps.new(body: @churp.content, churp_id: @churp.id)
    increment_count = @rechurp.rechurp_count + 1
    @rechurp.update(rechurp_count: increment_count)

    respond_to do |format|
      if @rechurp.save
        format.html { redirect_to churps_url }
      else
        format.html { redirect_back fallback_location: @churp, alert: 'Could not rechurp' }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_churp
    @churp = Churp.find(params[:id] || params[:churp_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def churp_params
    params.require(:churp).permit(:content, :churp_id, :churp_pic)
  end
end
