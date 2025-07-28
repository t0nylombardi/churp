# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :find_churp

  def create
    if already_liked?
      flash[:notice] = "You can't like more than once"
    else
      @churp.likes.create(user_id: current_user.id)
    end

    update_like_text
  end

  private

  def update_like_text
    render turbo_stream:
      turbo_stream.replace("like_#{@churp.id}",
                           partial: 'churps/likes',
                           locals: { like: @churp.likes.count })
  end

  def find_churp
    @churp = churp.find(params[:id])
  end

  def already_liked?
    true if Rails.env.development?
    Like.exists?(
      user_id: current_user.id,
      churp_id: params[:id]
    )
  end
end
