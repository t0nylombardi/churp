# frozen_string_literal: true

module Churps
  module Hashtags
    # Resolves tag names to persisted ids.
    class Resolver
      # @param hashtags [Array<Churps::Hashtags::Hashtag>]
      # @return [Hash{String=>String}]
      def self.call(hashtags)
        names = hashtags.map(&:name).map(&:downcase).uniq
        return {} if names.empty?

        resolved = HashTag.where(name: names).pluck(:name, :id).to_h
        return resolved
      end
    end
  end
end
