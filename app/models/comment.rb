# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id         :uuid             not null, primary key
#  content    :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  churp_id   :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_comments_on_churp_id  (churp_id)
#  index_comments_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (churp_id => churps.id)
#  fk_rails_...  (user_id => users.id)
#
class Comment < ApplicationRecord
  belongs_to :churp
  belongs_to :user

  validates :content, presence: true
  validate :content_must_be_structured
  validate :comment_length_within_limit

  private

  def content_must_be_structured
    return if content.is_a?(Hash) && content["blocks"].is_a?(Array)

    errors.add(:content, :invalid_structure)
  end

  def comment_length_within_limit
    text =
      content.fetch("blocks", [])
        .select { |b| b["type"] == "text" }
        .map { |b| b["content"].to_s }
        .join

    errors.add(:content, :too_long) if text.length > 331
  end
end
