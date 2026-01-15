# frozen_string_literal: true

module Churps
  module Hashtags
    # Usage aggregate for display or ranking.
    #
    # This is typically used for trending lists or analytics panels.
    class HashtagUsage < Dry::Struct
      transform_keys(&:to_sym)

      # @!attribute [r] name
      #   Normalized tag name (no # prefix).
      #   @return [String]
      attribute :name, Types::TagName

      # @!attribute [r] usage_count
      #   Number of churps referencing the tag.
      #   @return [Integer]
      attribute :usage_count, Types::UsageCount
    end
  end
end
