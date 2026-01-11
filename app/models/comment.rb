# frozen_string_literal: true

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
