# frozen_string_literal: true

# == Schema Information
#
# Table name: churps
#
#  id            :uuid             not null, primary key
#  body          :text
#  rechurp_count :uuid
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  churp_id      :uuid             not null
#  user_id       :uuid             not null
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
  has_many :hash_tags, through: :churp_hash_tags, dependent: :destroy
  has_many :noticed_events, as: :record, dependent: :destroy, class_name: "Noticed::Event"
  has_many :notifications, through: :noticed_events, dependent: :destroy, class_name: "Noticed::Notification"

  has_rich_text :body
  has_one_attached :churp_pic

  validates :churp_pic, acceptable_image: true
  validates :body, presence: true, churp_length: true

  scope :search_hashtags, ->(query) { joins(:hash_tags).where(hash_tags: { name: query }) }

  def churp_type
    churp_id.present? ? "rechurp" : "churp"
  end
end
