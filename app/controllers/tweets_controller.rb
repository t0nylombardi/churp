class TweetsController < ApplicationController
  before_action :authenticate_user!, except: %i[ show ]
  before_action :set_tweet, only: %i[ show edit update destroy like ]
  
  def index
    @pagy, @tweets = pagy(Tweet.order(created_at: :desc), items: 15)
    @tweet = current_user.tweets.new

    render 'scrollable_list' if params[:page]
  end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
    @user = User.friendly.find(params[:slug])
    @comment = current_user.comments.new
    @comments = @tweet.comments.recent_comments
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
          partial: 'tweets/shared/likes',
          locals: { tweet: @tweet }
        )
      end
      format.html { edirect_to tweets_path }
    end
  end

  def retweet
    @tweet = Tweet.find(params[:id])
    @retweet = current_user.tweets.new(tweet_id: @tweet.id)

    respond_to do |format|
      if @retweet.save
        puts "\n\n\n #{@retweet.inspect} \n\n\n"
        format.turbo_stream
      else
        puts "\n\n\n #{@retweet.errors.inspect} \n\n\n"
        format.html { redirect_back fallback_location: @tweet, alert: "Could not retweet" }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tweet
    @tweet = Tweet.find(params[:id] || params[:tweet_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tweet_params
    params.require(:tweet).permit(:body, :tweet_id, :churp_pic)
  end
end
