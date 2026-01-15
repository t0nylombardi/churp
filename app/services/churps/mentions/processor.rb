# frozen_string_literal: true

module Churps
  module Mentions
    class Processor
      def self.call(churp:, old_body: nil)
        new_mentions = Parser.call(churp.body["text"])
        old_mentions = old_body ? Parser.call(old_body["text"]) : []

        diff = Diff.call(old_mentions, new_mentions)
        return if diff[:added].empty?

        resolved = Resolver.call(diff[:added])

        ResolvedMentionBuilder.call(
          churp:,
          mentions: diff[:added],
          resolved_map: resolved
        )
      end
    end
  end
end
