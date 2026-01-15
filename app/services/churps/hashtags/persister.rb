# frozen_string_literal: true

module Churps
  module Hashtags
    # Persists hashtag associations for a churp.
    class Persister
      # @param churp [Churp]
      # @param resolved_map [Hash{String=>String}]
      # @return [void]
      def self.call(churp:, resolved_map:)
        return if resolved_map.blank?

        resolved_map.each_value do |hash_tag_id|
          ChurpHashTag.find_or_create_by!(churp:, hash_tag_id:)
        end

        return
      end
    end
  end
end
