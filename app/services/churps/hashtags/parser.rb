# frozen_string_literal: true

module Churps
  module Hashtags
    # Extracts hashtags from free-form text.
    class Parser
      HASHTAG_REGEX = /
        (?<!\w)
        \#([a-zA-Z0-9_]{1,50})
      /x

      # @param text [String, nil]
      # @return [Array<Churps::Hashtags::Hashtag>]
      def self.call(text)
        return [] if text.blank?

        hashtags = text.to_enum(:scan, HASHTAG_REGEX).map do
          match = Regexp.last_match

          Hashtag.new(
            name: match[1].downcase,
            start_index: match.begin(0),
            end_index: match.end(0)
          )
        end

        return hashtags.uniq(&:name)
      end
    end
  end
end
