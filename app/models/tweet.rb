class Tweet < ApplicationRecord
  belongs_to :user
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_one_attached :churp_pic

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
