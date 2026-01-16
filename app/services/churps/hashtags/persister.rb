# frozen_string_literal: true

module Churps
  module Hashtags
    # Persists hashtag associations for a churp.
    #
    # Expects a map of tag names to tag ids so the caller controls creation.
    class Persister
      # Persists churp associations for each resolved tag id.
      #
      # @param churp [Churp] churp to associate tags with
      # @param resolved_map [Hash{String=>String}] map of name to HashTag id
      # @return [void]
      def self.call(churp:, resolved_map:)
        return if resolved_map.blank?

        resolved_map.each_value do |hash_tag_id|
          ChurpHashTag.find_or_create_by!(churp:, hash_tag_id:)
        end
      end
    end
  end
end
