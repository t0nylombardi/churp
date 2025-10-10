# frozen_string_literal: true

# == Schema Information
#
# Table name: hash_tags
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class HashTag < ApplicationRecord
  include ActionText::Attachable

  has_many :churp_hash_tags, dependent: :restrict_with_exception
  has_many :churps, through: :churp_hash_tags

  # -- Scopes -------------------------------------------------------------

  scope :with_usage_counts, lambda {
    select("hash_tags.*, COUNT(churp_hash_tags.id) AS usage_count")
      .joins(:churp_hash_tags)
      .group("hash_tags.id")
  }

  scope :with_minimum_usage, ->(min_count = 2) {
    with_usage_counts.having("COUNT(churp_hash_tags.id) >= ?", min_count)
  }

  # -- Class Methods ------------------------------------------------------

  def self.most_popular(limit = nil)
    query = with_usage_counts.order("usage_count DESC")
    query = query.limit(limit) if limit
    query
  end

  def self.top_three
    most_popular(3)
  end

  # -- Instance Methods ---------------------------------------------------

  def usage_count
    read_attribute(:usage_count).to_i
  end
end
