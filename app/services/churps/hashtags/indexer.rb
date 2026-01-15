# frozen_string_literal: true

module Churps
  module Hashtags
    # Keeps hashtag search indexes up to date.
    #
    # Currently only updates usage counters; search indexing will be layered in
    # once Searchkick/OpenSearch integration is ready.
    class Indexer
      # Updates hashtag counters for the provided tags.
      #
      # TODO: integrate Searchkick/OpenSearch indexing strategy.
      #
      # @param tags [Array<HashTag>] persisted tags
      # @return [Integer] number of rows updated
      def self.call(tags)
        Hashtag.where(id: tags.map(&:id))
          .update_all("usage_count = usage_count + 1")
      end
    end
  end
end
