# frozen_string_literal: true

module Churps
  module Hashtags
    # Parsed hashtag extracted from a churp body.
    #
    # This value object preserves both the normalized name and its position in
    # the original string so downstream services can annotate or highlight.
    class Hashtag < Dry::Struct
      transform_keys(&:to_sym)

      # @!attribute [r] name
      #   Normalized tag name (no # prefix).
      #   @return [String]
      attribute :name, Types::TagName

      # @!attribute [r] start_index
      #   0-based offset where the hashtag begins.
      #   @return [Integer]
      attribute :start_index, Types::StartIndex

      # @!attribute [r] end_index
      #   0-based exclusive end offset of the hashtag.
      #   @return [Integer]
      attribute :end_index, Types::EndIndex
    end
  end
end
