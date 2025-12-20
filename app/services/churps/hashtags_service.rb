# frozen_string_literal: true

module Churps
  class HashtagsService < ApplicationService
    attr_reader :churp

    def initialize(churp:)
      @churp = churp
    end

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

    def extract_hashtags
      churp.body.to_s.scan(/#\w+/).map { |n| n.delete("#") }.uniq
    end
  end
end
