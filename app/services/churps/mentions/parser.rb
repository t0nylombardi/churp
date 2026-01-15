# frozen_string_literal: true

module Churps
  module Mentions
    class Parser
      MENTION_REGEX = /
        (?<!\w)
        @([a-zA-Z0-9_]{1,15})
      /x

      def self.call(text)
        return [] if text.blank?

        text.to_enum(:scan, MENTION_REGEX).map do
          match = Regexp.last_match

          Mention.new(
            username: match[1],
            start_index: match.begin(0),
            end_index: match.end(0)
          )
        end.uniq(&:username)
      end
    end
  end
end
