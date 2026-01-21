# frozen_string_literal: true

module Churps
  module Mentions
    # Parses @mentions from structured churp content text.
    #
    # Responsibilities:
    # - Scan plain text for valid @mentions
    # - Normalize usernames to match persisted User usernames
    # - Capture start/end indices for persistence + notifications
    # - Deduplicate mentions by username
    #
    # This class is intentionally dumb:
    # it does NOT hit the database, resolve users, or persist records.
    #
    # @example
    #   Parser.call("Hello @alice and @bob")
    #   #=> [
    #   #     #<Mention username="@alice", start_index=6, end_index=12>,
    #   #     #<Mention username="@bob", start_index=17, end_index=21>
    #   #   ]
    class Parser
      # Matches a mention beginning with "@", not preceded by a word character.
      #
      # Capture group 1 excludes the "@", so index math must account for it.
      #
      # Rules:
      # - Must start with "@"
      # - 1–15 alphanumeric or underscore characters
      # - No unicode, emojis, or hyphens (by design)
      MENTION_REGEX = /
        (?<!\w)              # not preceded by a word character
        @([a-zA-Z0-9_]{1,15}) # username without "@"
      /x

      # Parses mentions from a text string.
      #
      # @param text [String, nil] plain text extracted from churp content
      # @return [Array<Mention>] unique mention value objects
      def self.call(text)
        return [] if blank_text?(text)

        extract_matches(text)
          .map { |match| build_mention(match) }
          .then { |mentions| deduplicate(mentions) }
      end

      class << self
        private

        # Checks whether text is nil or empty after trimming.
        #
        # @param text [String, nil]
        # @return [Boolean]
        def blank_text?(text)
          text.nil? || text.strip.empty?
        end

        # Extracts raw regex matches from text.
        #
        # @param text [String]
        # @return [Array<MatchData>]
        def extract_matches(text)
          text.to_enum(:scan, MENTION_REGEX).map { Regexp.last_match }
        end

        # Builds a Mention value object from a regex match.
        #
        # @param match [MatchData]
        # @return [Mention]
        def build_mention(match)
          Mention.new(
            username: extract_username(match),
            start_index: extract_start_index(match),
            end_index: extract_end_index(match)
          )
        end

        # Normalizes the captured username to match persisted User records.
        #
        # @param match [MatchData]
        # @return [String] normalized username (e.g. "@alice")
        def extract_username(match)
          "@#{match[1]}"
        end

        # Calculates the starting index of the mention in the source string.
        #
        # @param match [MatchData]
        # @return [Integer]
        def extract_start_index(match)
          match.begin(1) - 1
        end

        # Calculates the ending index (exclusive) of the mention.
        #
        # @param match [MatchData]
        # @return [Integer]
        def extract_end_index(match)
          match.end(1)
        end

        # Deduplicates mentions by username.
        #
        # @param mentions [Array<Mention>]
        # @return [Array<Mention>]
        def deduplicate(mentions)
          mentions.uniq(&:username)
        end
      end
    end
  end
end
