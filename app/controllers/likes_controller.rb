class LikesController < ApplicationController
  before_action :find_tweet

  def create
    puts "\n\n Creating like \n\n"
    if already_liked?
      flash[:notice] = "You can't like more than once"
    else
      @tweet.likes.create(user_id: current_user.id)
    end

    update_like_text
  end

  private

  def update_like_text
    render turbo_stream:
      turbo_stream.replace('like',
                           partial: 'tweets/likes',
                           locals: { like: @tweet.likes.count })
  end

  def find_tweet
    @tweet = Tweet.find(params[:id])
  end

  def already_liked?
    Like.where(user_id: current_user.id,
               tweet_id: params[:id]).exists?
  end
end
