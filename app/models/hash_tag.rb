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
  searchkick word_start: [:name]

  has_many :churp_hash_tags, dependent: :restrict_with_exception
  has_many :churps, through: :churp_hash_tags

  scope :group_hashes, lambda {
    select(:name)
      .group(:name)
      .having('count(*) > 1').size
  }

  after_commit :reindex_hashtags

  def self.top_three
    most_popular.to_h.sort_by { |_k, v| -v }[0..3]
  end

  def self.most_popular
    metrics ||= group_hashes
    metrics.sort_by { |_key, value| value }.reverse.to_h
  end

  private

  def reindex_hashtags
    reindex
  end
end
