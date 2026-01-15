# frozen_string_literal: true

module Churps
  module Hashtags
    # Processes hashtags found in churp bodies.
    # Handles parsing, diffing, resolving, persisting, and indexing.
    # @see Churps::Hashtags::Parser
    # @see Churps::Hashtags::Resolver
    # @see Churps::Hashtags::Persister
    # @see Churps::Hashtags::Indexer
    class Processor
      include Dry::Monads[:result]

      # Processes hashtags for a churp body.
      #
      # The flow is: parse -> diff -> resolve -> persist -> index. If no new
      # tags are added, this returns Success(:no_tags).
      #
      # @param [Churp] churp churp being created or updated
      # @param [Hash, nil] old_body previous churp body hash, if updating
      #
      # @return [Dry::Monads::Result] Success with Hashtag array or :no_tags, or Failure
      def call(churp:, old_body: nil)
        new_tags = Parser.call(churp.body["text"])
        old_tags = old_body ? Parser.call(old_body["text"]) : []

        diff = Diff.call(old_tags, new_tags)
        return Success(:no_tags) if diff[:added].empty?

        resolved = Resolver.call(diff[:added])

        Persister.call(churp:, tags: resolved.values)
        Indexer.call(resolved.values)

        Success(resolved.values)
      rescue Dry::Types::ConstraintError => e
        Failure(e)
      end
    end
  end
end
