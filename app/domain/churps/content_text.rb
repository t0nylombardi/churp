# frozen_string_literal: true

module Churps
  # Extracts plain text from churp content hashes.
  module ContentText
    # @param content [Hash, String, nil]
    # @return [String]
    def self.extract(content)
      return "" if content.blank?

      if content.is_a?(Hash)
        direct = content["text"]
        return direct if direct.present?

        blocks = content.fetch("blocks", [])
        return "" if blocks.blank?

        return blocks
          .map { |block| block["text"] || block["content"] }
          .compact
          .join(" ")
      end

      content.to_s
    end
  end
end
