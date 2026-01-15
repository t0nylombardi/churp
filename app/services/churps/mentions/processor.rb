# frozen_string_literal: true

module Churps
  module Mentions
    class Processor
      def self.call(churp:)
        usernames = MentionParser.call(churp.body)
        return if usernames.empty?

        user_ids = MentionResolver.call(usernames)
        return if user_ids.empty?

        MentionPersister.call(
          churp: churp,
          mentioned_user_ids: user_ids
        )

        MentionNotifier.call(
          churp: churp,
          mentioned_user_ids: user_ids
        )
      end
    end
  end
end
