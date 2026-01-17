# frozen_string_literal: true

module Churps
  module Hashtags
    # Processes hashtags found in churp bodies.
    # Handles parsing, diffing, resolving, persisting, and indexing.
    class Processor
      include Dry::Monads[:result, :do]

      # @param churp [Churp]
      # @param old_body [Hash, nil]
      # @return [Dry::Monads::Result]
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

      def parse(text)
        Success(Parser.call(text))
      rescue Dry::Types::ConstraintError => e
        Failure(e)
      end

      def parse_old(old_body)
        return Success([]) if old_body.nil?

        parse(Churps::ContentText.extract(old_body))
      end

      def resolve(tags)
        Success(Resolver.call(tags))
      rescue ActiveRecord::RecordInvalid => e
        Failure(e)
      end

      def persist(churp, resolved)
        Persister.call(churp:, resolved_map: resolved)
        Success()
      rescue ActiveRecord::ActiveRecordError => e
        Failure(e)
      end

      def index(resolved)
        Indexer.call(resolved.values)
        Success()
      rescue => e
        Failure(e)
      end
    end
  end
end
