# frozen_string_literal: true

module Churps
  module Mentions
    class Diff
      def self.call(old_mentions, new_mentions)
        old_usernames = old_mentions.map(&:username)
        new_usernames = new_mentions.map(&:username)

        {
          added: new_mentions.select { |m| !old_usernames.include?(m.username) },
          removed: old_mentions.select { |m| !new_usernames.include?(m.username) }
        }
      end
    end
  end
end
