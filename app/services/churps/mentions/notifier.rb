# frozen_string_literal: true

module Churps
  module Mentions
    class Notifier
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
