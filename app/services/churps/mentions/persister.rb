# frozen_string_literal: true

module Churps
  module Mentions
    # Persists mention associations for a churp.
    #
    # Expects a resolved map of usernames to user ids so the caller controls
    # resolution and authorization.
    class Persister
      # Persists each mention as a ChurpMention record.
      #
      # @param churp [Churp] churp containing the mentions
      # @param mentions [Array<Churps::Mentions::Mention>] parsed mention objects
      # @param resolved_map [Hash{String=>Integer}] map of username to user id
      # @return [void]
      def self.call(churp:, mentions:, resolved_map:)
        mentions.each do |mention|
          user_id = resolved_map.fetch(mention.username)

          ::ChurpMention.create!(mention_body(churp, mention, user_id))
        end
      end

      class << self
        private

        # Builds attributes for the ChurpMention record.
        #
        # @param churp [Churp]
        # @param mention [Churps::Mentions::Mention]
        # @param user_id [Integer]
        # @return [Hash]
        def mention_body(churp, mention, user_id)
          {
            churp: churp,
            mentioned_user_id: user_id,
            start_index: mention.start_index,
            end_index: mention.end_index
          }
        end
      end
    end
  end
end
