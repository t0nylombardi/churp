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
  belongs_to :churp, optional: true, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :views
  has_many :churp_hash_tags, dependent: :destroy
  has_many :hash_tags, through: :churp_hash_tags, dependent: :destroy

  has_one_attached :churp_pic

  validates :churp_pic, acceptable_image: true
  validates :body, length: { maximum: 331 }, allow_blank: false, unless: :churp_id

  after_create :broadcast_churp
  after_commit :create_hash_tags, on: :create

  scope :search_hashtags, ->(query) { joins(:hash_tags).where(hash_tags: {name: query}) }

  def churp_type
    if churp_id? && body?
      'quote-churp'
    elsif churp_id?
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
    body.to_s.scan(/#\w+/).map { |name| name.gsub('#', '') }
  end

  private

  def broadcast_churp
    ActionCable.server.broadcast('churps_channel', rendered_churp)
  end

  def rendered_churp
    ApplicationController.renderer.render(
      partial: 'churps/churp',
      locals: { churp: self }
    )
  end
end
