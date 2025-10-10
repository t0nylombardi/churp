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

  scope :search_hashtags, ->(query) { joins(:hash_tags).where(hash_tags: { name: query }) }

  def churp_type
    churp_id.present? ? "rechurp" : "churp"
  end
end
