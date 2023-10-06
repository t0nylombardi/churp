class TweetsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_user!, except: %i[ show ]
  before_action :set_tweet, only: %i[ show edit update destroy like unlike ]
  
  def index
    @tweets = Tweet.all.order('created_at DESC')
    @tweet = current_user.tweets.new
  end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
  end

  # GET /tweets/new
  def new
    @tweet = current_user.tweets.build
  end

  # GET /tweets/1/edit
  def edit
  end

  # POST /tweets
  # POST /tweets.json
  def create
    @tweet = Tweet.new(tweet_params.merge(user: current_user))

    respond_to do |format|
      if @tweet.save
        format.html { redirect_to tweets_path, notice: "Tweet was successfully created." }
        format.json { render :show, status: :created, location: @tweet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tweets/1
  # PATCH/PUT /tweets/1.json
  def update
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.html { redirect_to @tweet, notice: 'tweet was successfully updated.' }
        format.json { render :show, status: :ok, location: @tweet }
      else
        format.html { render :edit }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy
    @tweet.destroy
    respond_to do |format|
      format.html { redirect_to tweets_url, notice: 'tweet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def like
    current_user.likes.create(likeable: @tweet)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
        'like',
        partial: 'tweets/likes',
        locals: { tweet: @tweet }
        )
      end
      format.html { edirect_to tweets_path }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tweet_params
    params.require(:tweet).permit(:body, :churp_pic)
  end
end
