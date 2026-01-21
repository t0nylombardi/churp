# frozen_string_literal: true

module Churps
  module Mentions
    # Orchestrates mention parsing, diffing, persistence, and notifications.
    #
    # This processor is pure service orchestration and does not implement
    # parsing or delivery itself.
    #
    # @example
    #   Churps::Mentions::Processor.new.call(churp: churp)
    class Processor
      include Dry::Monads[:result]

      # Processes mentions for a churp and returns added mentions.
      #
      # @param churp [Churp] churp containing mentions
      # @param old_body [Hash, nil] previous churp body (for edits)
      # @return [Dry::Monads::Result] Success with mentions or Failure
      def call(churp:, old_body: nil)
        new_mentions = parse_new_mentions(churp)
        old_mentions = parse_old_mentions(old_body)

        diff = diff_mentions(old_mentions, new_mentions)
        return Success(:no_mentions) if no_new_mentions?(diff)

        resolved = resolve_mentions(diff[:added])
        persist_mentions(churp:, mentions: diff[:added], resolved_map: resolved)
        notify_mentions(churp:, mentions: diff[:added], resolved_map: resolved)

        Success(diff[:added])
      rescue Dry::Types::ConstraintError => e
        Failure(e)
      end

      private

      # Parses mentions from the churp content.
      #
      # @param churp [Churp]
      # @return [Array<Churps::Mentions::Mention>]
      def parse_new_mentions(churp)
        Parser.call(extract_text(churp.content))
      end

      # Parses mentions from the previous body, if present.
      #
      # @param old_body [Hash, nil]
      # @return [Array<Churps::Mentions::Mention>]
      def parse_old_mentions(old_body)
        return [] unless old_body

        Parser.call(extract_text(old_body))
      end

      # Extracts plain text from structured content.
      #
      # @param content [Hash]
      # @return [String]
      def extract_text(content)
        Churps::ContentText.extract(content)
      end

      # Computes the diff between old and new mention sets.
      #
      # @param old_mentions [Array<Churps::Mentions::Mention>]
      # @param new_mentions [Array<Churps::Mentions::Mention>]
      # @return [Hash{Symbol=>Array<Churps::Mentions::Mention>}]
      def diff_mentions(old_mentions, new_mentions)
        Diff.call(old_mentions, new_mentions)
      end

      # Checks if any new mentions were added.
      #
      # @param diff [Hash{Symbol=>Array<Churps::Mentions::Mention>}]
      # @return [Boolean]
      def no_new_mentions?(diff)
        diff[:added].empty?
      end

      # Resolves usernames to user ids.
      #
      # @param mentions [Array<Churps::Mentions::Mention>]
      # @return [Hash{String=>Integer}]
      def resolve_mentions(mentions)
        Resolver.call(mentions)
      end

      # Persists ChurpMention records.
      #
      # @param churp [Churp]
      # @param mentions [Array<Churps::Mentions::Mention>]
      # @param resolved_map [Hash{String=>Integer}]
      # @return [void]
      def persist_mentions(churp:, mentions:, resolved_map:)
        Persister.call(churp:, mentions:, resolved_map:)
      end

      # Sends notifications to mentioned users.
      #
      # @param churp [Churp]
      # @param mentions [Array<Churps::Mentions::Mention>]
      # @param resolved_map [Hash{String=>Integer}]
      # @return [void]
      def notify_mentions(churp:, mentions:, resolved_map:)
        Notifier.call(churp:, mentions:, resolved_map:)
      end
    end
  end
end
