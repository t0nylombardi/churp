# frozen_string_literal: true

module Churps
  module Extractor
    class MentionSanitizer
      def initialize(entries)
        @entries = entries
      end

      def sanitize
        @entries.pluck(:screen_name)
          .map(&:strip)
          .compact_blank
          .uniq
      end
    end
  end
end
