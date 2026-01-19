# frozen_string_literal: true

module Churps
  module Mentions
    # Computes the added/removed mention sets.
    #
    # Delegates to {Shared::CollectionDiff} using the username as the key.
    #
    # @example
    #   diff = Churps::Mentions::Diff.call(old_mentions, new_mentions)
    #   diff[:added] #=> [...]
    class Diff
      # Uses Shared::CollectionDiff with the mention username as the key.
      #
      # @param old_mentions [Array<Churps::Mentions::Mention>]
      # @param new_mentions [Array<Churps::Mentions::Mention>]
      # @return [Hash{Symbol=>Array<Churps::Mentions::Mention>}]
      def self.call(old_mentions, new_mentions)
        Shared::CollectionDiff.call(
          old_mentions,
          new_mentions,
          key: :username
        )
      end
    end
  end
end
