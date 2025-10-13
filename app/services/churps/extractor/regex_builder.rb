# frozen_string_literal: true

module Churps
  module Extractor
    ##
    # == Churps::Extractor::RegexBuilder
    #
    # Builds and caches compiled regex patterns for extracting mentions.
    # Provides high performance through lazy initialization and internal caching.
    #
    # @example
    #   builder = Churps::Extractor::RegexBuilder.new
    #   builder.pattern_for(:valid_mention_or_list)
    #
    class RegexBuilder
      include CharacterSets

      def initialize
        @patterns = {}
      end

      def pattern_for(key)
        @patterns[key] ||= build_pattern(key)
      end

      private

      def build_pattern(key)
        case key
        when :spaces then /[#{UNICODE_SPACES.join}]/o
        when :directional_characters then /[#{DIRECTIONAL_CHARACTERS.join}]/o
        when :valid_mention_preceding_chars
          /(?:[^a-z0-9_!#$%&*@＠]|^|(?:^|[^a-z0-9_+~.-])[rR][tT]:?)/io
        when :at_signs then AT_SIGNS
        when :valid_mention_or_list then build_mention_or_list_pattern
        when :valid_reply then build_valid_reply_pattern
        when :end_mention_match then %r{\A(?:#{AT_SIGNS}|://)}io
        when :list_name then /[a-z][a-z0-9_\-\u0080-\u00ff]{0,24}/i
        else
          raise KeyError, "Unknown regex pattern key: #{key}"
        end
      end

      def build_mention_or_list_pattern
        mention_preceding = pattern_for(:valid_mention_preceding_chars)
        at_sign = pattern_for(:at_signs)

        %r{
          (#{mention_preceding})
          (#{at_sign})
          ([a-z0-9_]{1,20})
          (/[a-z][a-zA-Z0-9_-]{0,24})?
        }iox
      end

      def build_valid_reply_pattern
        at_sign = pattern_for(:at_signs)

        /
          ^
          (?:
            [#{UNICODE_SPACES.join}#{DIRECTIONAL_CHARACTERS.join}]
          )*
          #{at_sign}
          ([a-z0-9_]{1,20})
        /xio
      end
    end
  end
end
