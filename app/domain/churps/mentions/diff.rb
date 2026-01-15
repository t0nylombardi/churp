# frozen_string_literal: true

module Churps
  module Mentions
    class Diff
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
