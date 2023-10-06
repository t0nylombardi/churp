class Tweet < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy

  validates :body, presence: true

  after_create :broadcast_tweet

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
