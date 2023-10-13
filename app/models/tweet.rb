class Tweet < ApplicationRecord
  belongs_to :user
  belongs_to :tweet, optional: true
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_one_attached :churp_pic

  validates :body, length: { maximum: 300 }, allow_blank: false, unless: :tweet_id

  after_create :broadcast_tweet

  def tweet_type
    if tweet_id? && body?
      'quote-tweet'
    elsif tweet_id?
      'retweet'
    else
      'tweet'
    end
  end

  private

  def broadcast_tweet
    ActionCable.server.broadcast('tweets_channel', rendered_tweet)
  end

  def rendered_tweet
    ApplicationController.renderer.render(
      partial: 'tweets/tweet',
      locals: { tweet: self }
    )
  end
end
