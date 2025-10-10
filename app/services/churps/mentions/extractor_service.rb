# frozen_string_literal: true

module Churps
  module Mentions
    class ExtractorService < ApplicationService
      attr_reader :churp

      def initialize(churp:)
        @churp = churp
      end

      ##
      # Parses the churp body and returns a unique list of mentioned usernames.
      #
      # @return [Array<String>]
      def execute!
        raw_text = churp.body.to_s
        usernames = ChurpExtractor::Extractor.new.extract_mentioned_screen_names(raw_text)
        @result = usernames.uniq.compact
      rescue => e
        log_error("[ExtractorService] #{e.class}: #{e.message}")
        @result = []
        fail!
      end
    end
  end
end
