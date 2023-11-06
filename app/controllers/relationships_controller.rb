# frozen_string_literal: true

class RelationshipsController < ApplicationController
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)

    update_follow_card
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)

    update_follow_card
  end

  private

  def update_follow_card
    render turbo_stream: turbo_stream.replace(
      "follow_card_#{@user.id}",
      partial: 'users/follow',
      locals: { user: @user }
    )
  end
end
