# frozen_string_literal: true

# == Schema Information
#
# Table name: churps
#
#  id                :uuid             not null, primary key
#  content           :jsonb            not null
#  rechurp_count     :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  original_churp_id :uuid
#  user_id           :uuid             not null
#
# Indexes
#
#  index_churps_on_original_churp_id  (original_churp_id)
#  index_churps_on_user_id            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (original_churp_id => churps.id)
#  fk_rails_...  (user_id => users.id)
#
class Churp < ApplicationRecord
  belongs_to :user
  belongs_to :original_churp,
    class_name: "Churp",
    optional: true

  has_many :rechurps,
    class_name: "Churp",
    foreign_key: :original_churp_id,
    dependent: :destroy

  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :churp_hash_tags, dependent: :destroy
  has_many :hash_tags, through: :churp_hash_tags, dependent: :destroy
  has_many :noticed_events, as: :record, dependent: :destroy, class_name: "Noticed::Event"
  has_many :notifications, through: :noticed_events, dependent: :destroy, class_name: "Noticed::Notification"

  validates :content, presence: true, churp_length: true

  scope :search_hashtags, ->(query) { joins(:hash_tags).where(hash_tags: { name: query }) }

  def rechurp?
    original_churp.present?
  end

  def churp_type
    rechurp? ? "rechurp" : "churp"
  end
end
