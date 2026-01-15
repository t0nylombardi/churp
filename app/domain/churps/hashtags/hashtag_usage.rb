# frozen_string_literal: true

module Churps
  module Hashtags
    # Usage aggregate for display or ranking.
    class HashtagUsage < Dry::Struct
      transform_keys(&:to_sym)

      # @!attribute [r] name
      #   @return [String]
      attribute :name, Types::TagName

      # @!attribute [r] usage_count
      #   @return [Integer]
      attribute :usage_count, Types::UsageCount
    end
  end
end
