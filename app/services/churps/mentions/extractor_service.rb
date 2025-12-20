# frozen_string_literal: true

module Churps
  module Mentions
    class ExtractorService < ApplicationService
      attr_reader :churp

      def initialize(churp:)
        @churp = churp
      end

      def execute!
        raw_html = churp&.body&.to_s
        raise "[Mentions::ExtractorService] churp body missing" if raw_html.blank?

        text = sanitize_html(raw_html)
        parsed = Churps::Extractor::MentionExtractorService.call(text:)

        unless parsed.success?
          log_error("[Mentions::ExtractorService] underlying extractor failed")
          fail!
        end
        binding.pry
        @result = parsed.result.uniq.compact
      rescue => e
        log_error(format_error(e))
        @result = []
        fail!
      end

      private

      def sanitize_html(html)
        # Removes ActionText comment tags and decodes entities
        clean = ActionView::Base.full_sanitizer.sanitize(html)
        clean.gsub(/\s+/, " ").strip
      end

      def format_error(error)
        "[Mentions::ExtractorService] #{error.class}: #{error.message}\n#{error.backtrace&.first(3)&.join("\n")}"
      end
    end
  end
end
