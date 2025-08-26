# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[show edit update destroy]

  # GET /comments or /comments.json
  def index
    @comments = Comment.all.order("created_at DESC")
  end

  # GET /comments/1 or /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = current_user.comments.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments or /comments.json
  def create
    @comment = Comment.new(comment_params.merge(user: current_user))

    respond_to do |format|
      if @comment.save
        format.html { redirect_to churp_path(params[:churp_id]), notice: "Comment was successfully created." }
      else
        format.html { redirect_to churp_path(params[:churp_id]), alert: "Could not comment" }
      end
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to comment_url(@comment), notice: "Comment was successfully updated." }
        format.json { render :show, status: 200, location: @comment }
      else
        format.html { render :edit, status: 422 }
        format.json { render json: @comment.errors, status: 422 }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to churp_path(params[:churp_id]), notice: "Comment was successfully destroyed." }
      format.json { head 204 }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params
      .require(:comment)
      .permit(:content, :parent_id)
      .merge(churp_id: params[:churp_id])
  end
end
