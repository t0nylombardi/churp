# frozen_string_literal: true

# == Schema Information
#
# Table name: churps
#
#  id            :bigint           not null, primary key
#  rechurp_count :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  churp_id      :integer
#  user_id       :bigint           not null
#
# Indexes
#
#  index_churps_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Churp < ApplicationRecord
  include Twitter::TwitterText::Extractor

  belongs_to :user
  belongs_to :churp, optional: true, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, dependent: :destroy
  # TODO: This is for the analytics feature on a churp.
  #       The logic for this needs to be rewitten into a model
  #       insead of a tracking pixel. (stupid idea)
  # has_many :views
  has_many :churp_hash_tags, dependent: :destroy
  has_many :hash_tags, through: :churp_hash_tags, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy

  has_rich_text :content
  has_one_attached :churp_pic

  validates :churp_pic, acceptable_image: true
  validates :content, churp_length: true

  after_create :create_hash_tags
  after_create :broadcast_churp
  after_create_commit :broadcast_notifications

  scope :search_hashtags, ->(query) { joins(:hash_tags).where(hash_tags: { name: query }) }

  def churp_type
    if churp_id? && content?
      'rechurp'
    else
      'churp'
    end
  end

  def create_hash_tags
    extract_name_hash_tags.each do |name|
      hash_tags.create(name:)
    end
  end

  def extract_name_hash_tags
    content.to_s.scan(/#\w+/).map { |name| name.delete('#') }
  end

  private

  def broadcast_churp
    ActionCable.server.broadcast('churps_channel', rendered_churp)
  end

  def broadcast_notifications
    usernames = extract_usernames(text)

    return false unless usernames

    send_notifications(usernames)
  end

  def rendered_churp
    ApplicationController.renderer.render(
      partial: 'churps/churp',
      locals: { churp: self }
    )
  end

  def text
    content.body.to_s
  end

  def extract_usernames(text)
    usernames = extract_mentioned_screen_names(text)
    usernames.detect { |username| usernames.count(username) > 1 }.split unless usernames.empty?
  end

  def send_notifications(usernames)
    usernames.each do |username|
      user = User.friendly.find(username)
      MentionNotification.with(message: self).deliver_later(user)
      broadcast(user)
    end
  end

  def broadcast(user)
    count = user.unread_notifications.count
    broadcast_update_later_to "notifications_count_#{user.id}",
                               target: "notification_count_#{user.id}",
                               partial: 'mentions/notification_count',
                               locals: { user:, count: }
  end
end
