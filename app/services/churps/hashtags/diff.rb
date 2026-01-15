# frozen_string_literal: true

module Churps
  module Hashtags
    # Computes the added/removed hashtag sets.
    class Diff
      # @param old_hashtags [Array<Churps::Hashtags::Hashtag>]
      # @param new_hashtags [Array<Churps::Hashtags::Hashtag>]
      # @return [Hash{Symbol=>Array<Churps::Hashtags::Hashtag>}]
      def self.call(old_hashtags, new_hashtags)
        old_names = old_hashtags.map(&:name)
        new_names = new_hashtags.map(&:name)

        added = new_hashtags.reject { |hashtag| old_names.include?(hashtag.name) }
        removed = old_hashtags.reject { |hashtag| new_names.include?(hashtag.name) }

        return { added:, removed: }
      end
    end
  end
end
