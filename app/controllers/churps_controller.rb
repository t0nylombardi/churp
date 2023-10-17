# frozen_string_literal: true

class ChurpsController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :set_churp, only: %i[show edit update destroy like rechurp]

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

    respond_to do |format|
      if @churp.save
        format.html { redirect_to churps_path, notice: "churp was successfully created." }
        format.json { render :show, status: :created, location: @churp }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @churp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /churps/1
  # PATCH/PUT /churps/1.json
  def update
    respond_to do |format|
      if @churp.update(churp_params)
        format.html { redirect_to @churp, notice: 'churp was successfully updated.' }
        format.json { render :show, status: :ok, location: @churp }
      else
        format.html { render :edit }
        format.json { render json: @churp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /churps/1
  # DELETE /churps/1.json
  def destroy
    @churp.destroy
    respond_to do |format|
      format.html { redirect_to churps_url, notice: 'churp was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def like
    current_user.likes.create(likeable: @churp)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          'like',
          partial: 'churps/shared/likes',
          locals: { churp: @churp }
        )
      end
      format.html { edirect_to churps_path }
    end
  end

  def rechurp
    @rechurp = current_user.churps.new(churp_id: @churp.id)
    @rechurp.increment!(:rechurp_count, 1)

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
    params.require(:churp).permit(:body, :churp_id, :churp_pic)
  end
end