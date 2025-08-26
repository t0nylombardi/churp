# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[following followers]

  def following
    @pagy, @following = pagy(@user.following, items: 15)
    @is_active = true

    render "users/scrollable_list" if params[:page]
  end

  def followers
    @pagy, @followers = pagy(@user.followers, items: 15)
    @is_active = true

    render "users/scrollable_list" if params[:page]
  end

  private

  def set_user
    @user = User.friendly.find(params[:id])
  end
end
