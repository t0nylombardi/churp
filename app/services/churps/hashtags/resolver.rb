# frozen_string_literal: true

module Churps
  module Hashtags
    # Resolves tag names to persisted records.
    class Resolver
      # Resolves names to persisted records, creating any missing tags.
      #
      # @param hashtags [Array<Churps::Hashtags::Hashtag>] parsed hashtag objects
      # @return [Hash{String=>Hashtag}] map of normalized name to persisted tag
      def self.call(hashtags)
        names = hashtags.map(&:name)

        existing = Hashtag.where(name: names).index_by(&:name)

        names.each do |name|
          existing[name] ||= Hashtag.create!(name:)
        end

        existing
      end
    end
  end
end
