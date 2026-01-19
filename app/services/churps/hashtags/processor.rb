# frozen_string_literal: true

module Churps
  module Hashtags
    # Processes hashtags found in churp bodies.
    # Handles parsing, diffing, resolving, persisting, and indexing.
    class Processor
      include Dry::Monads[:result, :do]

      # Orchestrates the hashtag pipeline for a churp body.
      #
      # @param churp [Churp] churp being processed
      # @param old_body [Hash, nil] previous churp body (for edits)
      # @return [Dry::Monads::Result] Success with tags or Failure with error
      def call(churp:, old_body: nil)
        new_tags = yield parse(Churps::ContentText.extract(churp.content))
        old_tags = yield parse_old(old_body)

        diff = Diff.call(old_tags, new_tags)
        return Success(:no_tags) if diff[:added].empty?

        resolved = yield resolve(diff[:added])
        yield persist(churp, resolved)
        yield index(resolved)

        Success(resolved.values)
      end

      private

      # Parses raw text into hashtag value objects.
      #
      # @param text [String]
      # @return [Dry::Monads::Result]
      def parse(text)
        Success(Parser.call(text))
      rescue Dry::Types::ConstraintError => e
        Failure(e)
      end

      # Parses previous body into hashtag value objects, if provided.
      #
      # @param old_body [Hash, nil]
      # @return [Dry::Monads::Result]
      def parse_old(old_body)
        return Success([]) if old_body.nil?

        parse(Churps::ContentText.extract(old_body))
      end

      # Resolves tag names to persisted HashTag records.
      #
      # @param tags [Array<Churps::Hashtags::Hashtag>]
      # @return [Dry::Monads::Result]
      def resolve(tags)
        Success(Resolver.call(tags))
      rescue ActiveRecord::RecordInvalid => e
        Failure(e)
      end

      # Persists churp/tag associations.
      #
      # @param churp [Churp]
      # @param resolved [Hash{String=>HashTag}]
      # @return [Dry::Monads::Result]
      def persist(churp, resolved)
        Persister.call(churp:, resolved_map: resolved)
        Success()
      rescue ActiveRecord::ActiveRecordError => e
        Failure(e)
      end

      # Updates hashtag indexes/counters.
      #
      # @param resolved [Hash{String=>HashTag}]
      # @return [Dry::Monads::Result]
      def index(resolved)
        Indexer.call(resolved.values)
        Success()
      rescue => e
        Failure(e)
      end
    end
  end
end
