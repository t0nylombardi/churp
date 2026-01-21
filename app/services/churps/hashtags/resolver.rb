# frozen_string_literal: true

module Churps
  module Hashtags
    # Resolves tag names to persisted records.
    #
    # Ensures each parsed hashtag has a corresponding HashTag record.
    # Missing tags are created inside this resolver.
    class Resolver
      # Resolves names to persisted records, creating any missing tags.
      #
      # @param hashtags [Array<Churps::Hashtags::Hashtag>] parsed hashtag objects
      # @return [Hash{String=>HashTag}] map of normalized name to persisted tag
      def self.call(hashtags)
        names = hashtags.map(&:name)

        existing = HashTag.where(name: names).index_by(&:name)

        names.each do |name|
          existing[name] ||= HashTag.create!(name:)
        end

        existing
      end
    end
  end
end
