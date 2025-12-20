# frozen_string_literal: true

module Churps
  module Extractor
    # Responsible for low-level regex parsing of mentions.
    # Does NOT know about sanitization or application concerns.
    class MentionParser
      include ActionView::Helpers::SanitizeHelper
      require "English"

      def initialize(text)
        @text = text.to_s
      end

      def parse
        return [] if @text.blank?
        return [] unless matchable?

        matches = []
        @text.scan(Churps::Extractor::Regex[:valid_mention_or_list]) do |_before, _at, screen_name, list_slug|
          md = $LAST_MATCH_INFO
          after = ::Regexp.last_match.post_match
          next unless valid_end?(after, list_slug)

          matches << build_entry(md, screen_name, list_slug)
        end
        matches
      end

      private

      def matchable?
        @text.match?(Churps::Extractor::Regex[:at_signs])
      end

      def valid_end?(after, list_slug)
        after.match?(Churps::Extractor::Regex[:end_mention_match])
      end

      def build_entry(match_data, screen_name, list_slug)
        {
          screen_name: sanitize(screen_name),
          indices: [match_data.begin(3) - 1, match_data.end(list_slug.nil? ? 3 : 4)]
        }
      end
    end
  end
end
