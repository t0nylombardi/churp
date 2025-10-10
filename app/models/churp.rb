# frozen_string_literal: true

# == Schema Information
#
# Table name: churps
#
#  id            :bigint           not null, primary key
#  body          :text
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
  belongs_to :user
  belongs_to :churp, optional: true
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :churp_hash_tags, dependent: :destroy
  has_many :hash_tags, through: :churp_hash_tags
  has_many :noticed_events, as: :record, dependent: :destroy, class_name: "Noticed::Event"
  has_many :notifications, through: :noticed_events, class_name: "Noticed::Notification"

  has_rich_text :body
  has_one_attached :churp_pic

  validates :churp_pic, acceptable_image: true
  validates :body, presence: true, churp_length: true

  after_commit :create_hash_tags
  after_commit :broadcast_churp
  after_commit :broadcast_notifications

  scope :search_hashtags, ->(query) { joins(:hash_tags).where(hash_tags: { name: query }) }

  def churp_type
    churp_id.present? ? "rechurp" : "churp"
  end

  def create_hash_tags
    return if extract_name_hash_tags.blank?

    extract_name_hash_tags.each do |name|
      tag = HashTag.find_or_create_by(name:)
      churp_hash_tags.find_or_create_by(hash_tag: tag)
    end
  rescue => e
    Rails.logger.error "[Churp##{id}] Failed to create hashtags: #{e.message}"
  end

  def extract_name_hash_tags
    body.to_s.scan(/#\w+/).map { |name| name.delete("#") }.uniq
  end

  private

  def broadcast_churp
    ActionCable.server.broadcast("churps_channel", rendered_churp)
  rescue => e
    Rails.logger.error "[Churp##{id}] Failed to broadcast churp: #{e.message}"
  end

  def rendered_churp
    ApplicationController.renderer.render(
      partial: "churps/churp",
      locals: { churp: self }
    )
  end

  def broadcast_notifications
    BroadcastNotificationsService.new(self).execute!
  rescue => e
    Rails.logger.error "[Churp##{id}] Failed to broadcast notifications: #{e.message}"
  end
end
