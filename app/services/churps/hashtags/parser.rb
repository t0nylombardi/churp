# frozen_string_literal: true

module Churps
  module Hashtags
    # Extracts hashtags from free-form text.
    class Parser
      # Matches hashtags without leading word characters.
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
