# frozen_string_literal: true

module Churps
  module Mentions
    class Persister
      def self.call(churp:, mentioned_user_ids:)
        mentioned_user_ids.each do |user_id|
          ChurpMention.create!(
            churp: churp,
            mentioned_user_id: user_id
          )
        end
      end
    end
  end
end
