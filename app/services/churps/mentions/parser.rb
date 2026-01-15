# frozen_string_literal: true

module Churps
  module Mentions
    class Parser
      MENTION_REGEX = /
        (?<!\w)
        @
        ([a-zA-Z0-9_]{1,15})
      /x

      def self.call(body)
        text = extract_text(body)
        return [] if text.blank?

        text.scan(MENTION_REGEX).flatten.uniq
      end

      def self.extract_text(body)
        case body
        when Hash
          body["text"] || body[:text]
        else
          body.to_s
        end
      end
    end
  end
end
