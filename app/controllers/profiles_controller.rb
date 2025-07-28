# frozen_string_literal: true

class ProfilesController < ApplicationController
  include ActiveStorage::SetCurrent
  before_action :set_profile, only: %i[show edit update follow unfollow]

  def show
    @user_churps = @profile.user.churps
  end

  # profile /profiles or /profiles.json
  def new
    @profile = current_user.build_profile
  end

  def edit; end

  # profile /profiles or /profiles.json
  def create
    @profile = Profile.new(profile_params)

    respond_to do |format|
      if @profile.save
        format.html { redirect_to profile_url(current_user.id), notice: 'profile was successfully created.' }
        format.json { render :show, status: 201, location: @profile }
      else
        format.html { render :show, status: 422 }
        format.json { render json: @profile.errors, status: 422 }
      end
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to profile_url(current_user.id), notice: 'profile was successfully created.' }
        format.json { render :show, status: 201, location: @profile }
      else
        format.html { render :new, status: 422 }
        format.json { render json: @profile.errors, status: 422 }
      end
    end
  end

  def follow
    @user = User.friendly.find(params[:id].downcase.delete('@'))
    @user_churps = @profile.user.churps
    current_user.follow(@user)

    update_follow_card
  end

  def unfollow
    @user = @profile.user
    @user_churps = @profile.user.churps
    current_user.unfollow(@user)

    update_follow_card
  end

  private

  def update_follow_card
    render turbo_stream: turbo_stream.replace(
      "profile_follow_#{@profile.id}",
      partial: 'profiles/follow_button',
      locals: { profile: @profile }
    )
  end

  def set_profile
    username = params[:id].downcase.delete('@')
    @profile = User.friendly.find(username).profile
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def profile_params
    params.require(:profile).permit(
      :name,
      :description,
      :website,
      :birth_date,
      :profile_bg,
      :profile_pic,
      :user_id
    )
  end
end
