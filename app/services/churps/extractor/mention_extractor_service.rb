# frozen_string_literal: true

module Churps
  module Extractor
    class MentionExtractorService < ApplicationService
      require "nokogiri"

      attr_reader :text

      def initialize(text:)
        @text = text
      end

      def execute!
        cleaned_text = extract_mentions_from_attachments(text)
        mentions = extract_screen_names(cleaned_text)
        @result = mentions.uniq.compact
        @success = true
      rescue => e
        log_error("[MentionExtractorService] #{e.class}: #{e.message}")
        @result = []
        fail!
      end

      private

      # Extracts @mentions from both visible HTML and ActionText attachments
      def extract_mentions_from_attachments(raw_html)
        doc = Nokogiri::HTML.fragment(raw_html)

        mentions = []

        # Extract from visible <a> tags inside .mention spans
        doc.css("span.mention a").each do |a|
          mentions << a.text.strip
        end

        # Extract from <action-text-attachment> content attributes (if any)
        doc.css("action-text-attachment").each do |node|
          if (content = node["content"])
            inner = Nokogiri::HTML.fragment(content)
            inner.css("a").each { |a| mentions << a.text.strip }
          end
        end

        mentions.join(" ")
      end

      def extract_screen_names(content)
        parser = MentionParser.new(content)
        sanitizer = MentionSanitizer.new(parser.parse)
        sanitizer.sanitize
      end
    end
  end
end
