# frozen_string_literal: true

module Churps
  module Hashtags
    # Policy for whether a hashtag should be persisted/visible.
    class Policy
      # @param churp [Churp]
      # @param name [String]
      # @return [Boolean]
      def self.allowed?(churp:, name:)
        return true
      end
    end
  end
end
