# frozen_string_literal: true

module Churps
  module Hashtags
    # Extracts hashtags from free-form text.
    #
    # Responsibilities:
    # - Scan text for valid hashtag tokens
    # - Normalize tag names for persistence
    # - Capture start/end indices for UI highlights
    # - Deduplicate tags by name
    #
    # This class does not query the database or persist records.
    #
    # @example
    #   Parser.call("Hello #Ruby and #rails")
    #   #=> [
    #   #     #<Hashtag name="ruby", start_index=6, end_index=11>,
    #   #     #<Hashtag name="rails", start_index=16, end_index=22>
    #   #   ]
    class Parser
      # Matches hashtags without leading word characters.
      #
      # Rules:
      # - Must start with "#"
      # - 1–50 alphanumeric or underscore characters
      # - No unicode, emojis, or hyphens (by design)
      REGEX = /
        (?<!\w)
        \#([a-zA-Z0-9_]{1,50})
      /x

      # Parses text into unique hashtag value objects.
      #
      # @param text [String, nil] churp content text
      # @return [Array<Churps::Hashtags::Hashtag>] normalized, unique hashtags
      def self.call(text)
        return [] if text.blank?

        text.to_enum(:scan, REGEX).map do
          match = Regexp.last_match

          Hashtag.new(
            name: match[1].downcase,
            start_index: match.begin(0),
            end_index: match.end(0)
          )
        end.uniq(&:name)
      end
    end
  end
end
