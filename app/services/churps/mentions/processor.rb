# frozen_string_literal: true

module Churps
  module Mentions
    class Processor
      include Dry::Monads[:result]

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

      def parse_new_mentions(churp)
        Parser.call(extract_text(churp.content))
      end

      def parse_old_mentions(old_body)
        return [] unless old_body

        Parser.call(extract_text(old_body))
      end

      def extract_text(content)
        Churps::ContentText.extract(content)
      end

      def diff_mentions(old_mentions, new_mentions)
        Diff.call(old_mentions, new_mentions)
      end

      def no_new_mentions?(diff)
        diff[:added].empty?
      end

      def resolve_mentions(mentions)
        Resolver.call(mentions)
      end

      def persist_mentions(churp:, mentions:, resolved_map:)
        Persister.call(churp:, mentions:, resolved_map:)
      end

      def notify_mentions(churp:, mentions:, resolved_map:)
        Notifier.call(churp:, mentions:, resolved_map:)
      end
    end
  end
end
