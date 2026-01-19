# frozen_string_literal: true

module Churps
  module Mentions
    # Delivers mention notifications for a churp.
    #
    # Responsibilities:
    # - Skip notifications for unknown usernames
    # - Avoid notifying the churp author
    # - Enqueue notification delivery via ActiveJob
    #
    # @example
    #   Notifier.call(churp: churp, mentions: mentions, resolved_map: resolved)
    class Notifier
      # Delivers notifications for each mention.
      #
      # @param churp [Churp] churp that contains the mentions
      # @param mentions [Array<Churps::Mentions::Mention>] parsed mention objects
      # @param resolved_map [Hash{String=>Integer}] map of username to user id
      # @return [void]
      def self.call(churp:, mentions:, resolved_map:)
        mentions.each do |mention|
          user_id = resolved_map[mention.username]
          next unless user_id
          next if user_id == churp.user_id

          MentionNotification
            .with(
              churp_id: churp.id,
              start_index: mention.start_index,
              end_index: mention.end_index
            )
            .deliver_later(
              User.find(user_id),
              actor: churp.user
            )
        end
      end
    end
  end
end
