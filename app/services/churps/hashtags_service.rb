# frozen_string_literal: true

module Churps
  # Associates hashtags found in a churp's content with the churp.
  #
  # Responsibilities:
  # - Extract hashtag names from the churp body
  # - Create missing HashTag records
  # - Ensure ChurpHashTag join records exist
  #
  # This is a legacy, direct implementation kept for simple workflows.
  # For richer parsing/diffing, prefer {Churps::Hashtags::Processor}.
  #
  # @example
  #   Churps::HashtagsService.call(churp: churp)
  class HashtagsService < ApplicationService
    # @return [Churp] churp to tag
    attr_reader :churp

    # @param churp [Churp] churp whose content is parsed for hashtags
    def initialize(churp:)
      @churp = churp
    end

    # Extracts hashtags and persists associations.
    #
    # @return [void]
    def execute!
      names = extract_hashtags
      return if names.blank?

      names.each do |name|
        tag = HashTag.find_or_create_by(name:)
        churp.churp_hash_tags.find_or_create_by(hash_tag: tag)
      end
    rescue => e
      log_error("[HashtagsService] Failed to create hashtags for churp #{churp.id}: #{e.message}")
      fail!
    end

    private

    # Extracts unique hashtag names from the churp content.
    #
    # @return [Array<String>] unique, normalized hashtag names
    def extract_hashtags
      Churps::ContentText.extract(churp.content).scan(/#\w+/).map { |n| n.delete("#") }.uniq
    end
  end
end
