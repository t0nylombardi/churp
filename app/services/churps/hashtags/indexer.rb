# frozen_string_literal: true

module Churps
  module Hashtags
    # Keeps hashtag search indexes up to date.
    class Indexer
      # @param hash_tags [Array<HashTag>]
      # @return [Array<HashTag>]
      def self.call(hash_tags)
        return [] if hash_tags.blank?

        # TODO: integrate Searchkick/OpenSearch indexing strategy.
        return hash_tags
      end
    end
  end
end
