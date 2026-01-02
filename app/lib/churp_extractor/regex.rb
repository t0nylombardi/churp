# frozen_string_literal: true

module ChurpExtractor
  # Defines character sets and patterns used throughout the text extraction system.
  # This module isolates all Unicode character definitions and provides them
  # as constants for reuse across the application.
  module CharacterSets
    # Unicode whitespace characters as defined by Unicode standard
    UNICODE_SPACES = [
      (0x0009..0x000D).to_a,
      0x0020, 0x0085, 0x00A0, 0x1680, 0x180E,
      (0x2000..0x200A).to_a, 0x2028, 0x2029,
      0x202F, 0x205F, 0x3000
    ].flatten.map { |c| [c].pack("U*") }.freeze

    # Bidirectional text control characters per Unicode standard
    DIRECTIONAL_CHARACTERS = [
      0x061C, 0x200E, 0x200F, 0x202A, 0x202B, 0x202C,
      0x202D, 0x202E, 0x2066, 0x2067, 0x2068, 0x2069
    ].map { |cp| [cp].pack("U") }.freeze

    # Characters that may precede a mention in valid syntax
    AT_SIGNS = /[@＠]/

    private_constant :UNICODE_SPACES
    private_constant :DIRECTIONAL_CHARACTERS
    private_constant :AT_SIGNS
  end

  # Builds and caches compiled regex patterns for text extraction.
  # Follows the Single Responsibility Principle by focusing solely on pattern compilation.
  # Uses lazy initialization to optimize performance.
  class RegexBuilder
    include CharacterSets

    def initialize
      @patterns = {}
    end

    # Retrieves a compiled pattern by key, building it if necessary
    #
    # @param key [Symbol] the identifier for the regex pattern
    # @return [Regexp] the compiled pattern
    # @raise [KeyError] if the key is not a recognized pattern
    def pattern_for(key)
      @patterns[key] ||= build_pattern(key)
    end

    private

    # Constructs patterns based on their identifier.
    # Organized by pattern category for clarity and maintainability.
    #
    # @param key [Symbol] the pattern identifier
    # @return [Regexp] the compiled regex pattern
    # @raise [KeyError] if pattern key is not recognized
    def build_pattern(key)
      case key
      when :spaces
        /[#{UNICODE_SPACES.join}]/o
      when :directional_characters
        /[#{DIRECTIONAL_CHARACTERS.join}]/o
      when :valid_mention_preceding_chars
        /(?:[^a-z0-9_!#$%&*@＠]|^|(?:^|[^a-z0-9_+~.-])[rR][tT]:?)/io
      when :at_signs
        AT_SIGNS
      when :valid_mention_or_list
        build_mention_or_list_pattern
      when :valid_reply
        build_valid_reply_pattern
      when :end_mention_match
        %r{\A(?:#{AT_SIGNS}|://)}io
      when :list_name
        /[a-z][a-z0-9_\-\u0080-\u00ff]{0,24}/i
      else
        raise KeyError, "Unknown pattern key: #{key}"
      end
    end

    # Constructs the complex mention or list pattern by composing simpler patterns
    #
    # @return [Regexp] pattern for matching mentions or list references
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

    # Constructs the valid reply pattern by composing character set patterns
    #
    # @return [Regexp] pattern for matching valid reply mentions
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

  # Provides access to compiled regex patterns through a simple interface.
  # Acts as a facade and registry for pattern access across the application.
  # Implements the Singleton pattern to ensure consistent pattern caching.
  class Regex
    class << self
      # Retrieves a compiled regex pattern by key
      #
      # @param key [Symbol] the pattern identifier
      # @return [Regexp] the compiled pattern
      # @example
      #   ChurpExtractor::Regex[:valid_mention_or_list] => #<Regexp>
      def [](key)
        builder.pattern_for(key)
      end

      private

      # Returns the singleton builder instance
      #
      # @return [RegexBuilder] the pattern builder
      def builder
        @builder ||= RegexBuilder.new
      end
    end
  end
end
