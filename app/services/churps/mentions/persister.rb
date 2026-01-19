# frozen_string_literal: true

module Churps
  module Mentions
    class Persister
      # <Description>
      #
      # @param [<Type>] churp <description>
      # @param [<Type>] mentions <description>
      # @param [<Type>] resolved_map <description>
      #
      # @return [<Type>] <description>
      def self.call(churp:, mentions:, resolved_map:)
        mentions.each do |mention|
          binding.pry
          user_id = resolved_map.fetch(mention.username)

          ChurpMention.create!(mention_body(churp, mention, user_id))
        end
      end

      private

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
