# frozen_string_literal: true

module Churps
  module Extractor
    ##
    # == Churps::Extractor::CharacterSets
    #
    # Defines Unicode character sets and patterns used for mention extraction.
    # Mirrors Mastodon’s approach for robust international text parsing.
    #
    # Isolated here to separate static data from regex logic.
    #
    module CharacterSets
      UNICODE_SPACES = [
        (0x0009..0x000D).to_a,
        0x0020, 0x0085, 0x00A0, 0x1680, 0x180E,
        (0x2000..0x200A).to_a, 0x2028, 0x2029,
        0x202F, 0x205F, 0x3000
      ].flatten.map { |c| [c].pack("U*") }.freeze

      DIRECTIONAL_CHARACTERS = [
        0x061C, 0x200E, 0x200F, 0x202A, 0x202B, 0x202C,
        0x202D, 0x202E, 0x2066, 0x2067, 0x2068, 0x2069
      ].map { |cp| [cp].pack("U") }.freeze

      AT_SIGNS = /[@＠]/

      private_constant :UNICODE_SPACES, :DIRECTIONAL_CHARACTERS, :AT_SIGNS
    end
  end
end
