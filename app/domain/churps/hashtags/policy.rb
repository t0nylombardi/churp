# frozen_string_literal: true

module Churps
  module Hashtags
    # Policy for whether a hashtag should be persisted/visible.
    class Policy
      # Determines whether a tag is allowed for a specific churp.
      #
      # @param churp [Churp] churp that owns the tag
      # @param name [String] normalized tag name
      # @return [Boolean] whether the tag is allowed for persistence/visibility
      def self.allowed?(churp:, name:)
        true
      end
    end
  end
end
