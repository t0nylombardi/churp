# frozen_string_literal: true

module Churps
  module Hashtags
    # Computes the added/removed hashtag sets.
    class Diff
      # Uses Shared::CollectionDiff with the hashtag name as the key.
      #
      # @param old_hashtags [Array<Churps::Hashtags::Hashtag>]
      # @param new_hashtags [Array<Churps::Hashtags::Hashtag>]
      # @return [Hash{Symbol=>Array<Churps::Hashtags::Hashtag>}] diff hash
      def self.call(old_hashtags, new_hashtags)
        Shared::CollectionDiff.call(
          old_hashtags,
          new_hashtags,
          key: :name
        )
      end
    end
  end
end
