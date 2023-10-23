class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: %i[show update]

  def index
    @user_churps = current_user.churps
  end
  
  def show
    @user_churps = current_user.churps
  end

  # profile /profiles or /profiles.json
  def new
    @profile = current_user.build_profile
  end

  # profile /profiles or /profiles.json
  def create
    @profile = Profile.new(profile_params.merge(user_id: current_user.id))

    respond_to do |format|
      if @profile.save!
        format.html { redirect_to profile_url(current_user.id), notice: 'profile was successfully created.' }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @profile = User.find(params[:id]).profile
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    puts "\n\n\n params_id:#{params[:id]} \n\n\n"
    puts "\n\n\n #{@profile.inspect} \n\n\n"

    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to profile_url(current_user.id), notice: 'profile was successfully created.' }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_profile
    @profile = User.find(params[:id]).profile
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
