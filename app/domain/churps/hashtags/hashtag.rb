# frozen_string_literal: true

module Churps
  module Hashtags
    # Parsed hashtag extracted from a churp body.
    class Hashtag < Dry::Struct
      transform_keys(&:to_sym)

      # @!attribute [r] name
      #   @return [String]
      attribute :name, Types::TagName

      # @!attribute [r] start_index
      #   @return [Integer]
      attribute :start_index, Types::StartIndex

      # @!attribute [r] end_index
      #   @return [Integer]
      attribute :end_index, Types::EndIndex
    end
  end
end
