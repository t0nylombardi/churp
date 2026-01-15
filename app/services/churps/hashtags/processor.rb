# frozen_string_literal: true

module Churps
  module Hashtags
    # Orchestrates parsing, diffing, and persistence.
    class Processor
      # @param churp [Churp]
      # @param old_body [Hash, nil]
      # @return [void]
      def self.call(churp:, old_body: nil)
        new_hashtags = Parser.call(churp.body["text"])
        old_hashtags = old_body ? Parser.call(old_body["text"]) : []

        diff = Diff.call(old_hashtags, new_hashtags)
        return if diff[:added].empty?

        resolved = Resolver.call(diff[:added])
        Persister.call(churp:, resolved_map: resolved)

        return
      end
    end
  end
end
