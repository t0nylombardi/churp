# frozen_string_literal: true

module ChurpExtractor
  class Regex
    require 'yaml'

    REGEXEN = {}.freeze

    # Space is more than %20, U+3000 for example is the full-width space used with Kanji. Provide a short-hand
    # to access both the list of characters and a pattern suitible for use with String#split
    #  Taken from: ActiveSupport::Multibyte::Handlers::UTF8Handler::UNICODE_WHITESPACE
    UNICODE_SPACES = [
      (0x0009..0x000D).to_a, # White_Space # Cc   [5] <control-0009>..<control-000D>
      0x0020,          # White_Space # Zs       SPACE
      0x0085,          # White_Space # Cc       <control-0085>
      0x00A0,          # White_Space # Zs       NO-BREAK SPACE
      0x1680,          # White_Space # Zs       OGHAM SPACE MARK
      0x180E,          # White_Space # Zs       MONGOLIAN VOWEL SEPARATOR
      (0x2000..0x200A).to_a, # White_Space # Zs  [11] EN QUAD..HAIR SPACE
      0x2028,          # White_Space # Zl       LINE SEPARATOR
      0x2029,          # White_Space # Zp       PARAGRAPH SEPARATOR
      0x202F,          # White_Space # Zs       NARROW NO-BREAK SPACE
      0x205F,          # White_Space # Zs       MEDIUM MATHEMATICAL SPACE
      0x3000           # White_Space # Zs       IDEOGRAPHIC SPACE
    ].flatten.map { |c| [c].pack('U*') }.freeze
    REGEXEN[:spaces] = /[#{UNICODE_SPACES.join}]/o

    DIRECTIONAL_CHARACTERS = [
      0x061C,          # ARABIC LETTER MARK (ALM)
      0x200E,          # LEFT-TO-RIGHT MARK (LRM)
      0x200F,          # RIGHT-TO-LEFT MARK (RLM)
      0x202A,          # LEFT-TO-RIGHT EMBEDDING (LRE)
      0x202B,          # RIGHT-TO-LEFT EMBEDDING (RLE)
      0x202C,          # POP DIRECTIONAL FORMATTING (PDF)
      0x202D,          # LEFT-TO-RIGHT OVERRIDE (LRO)
      0x202E,          # RIGHT-TO-LEFT OVERRIDE (RLO)
      0x2066,          # LEFT-TO-RIGHT ISOLATE (LRI)
      0x2067,          # RIGHT-TO-LEFT ISOLATE (RLI)
      0x2068,          # FIRST STRONG ISOLATE (FSI)
      0x2069           # POP DIRECTIONAL ISOLATE (PDI)
    ].map { |cp| [cp].pack('U') }.freeze
    REGEXEN[:directional_characters] = /[#{DIRECTIONAL_CHARACTERS.join}]/o

    REGEXEN[:valid_mention_preceding_chars] = /(?:[^a-z0-9_!#$%&*@＠]|^|(?:^|[^a-z0-9_+~.-])[rR][tT]:?)/io
    REGEXEN[:at_signs] = /[@＠]/
    REGEXEN[:valid_mention_or_list] = %r{
      (#{REGEXEN[:valid_mention_preceding_chars]})  # $1: Preceeding character
      (#{REGEXEN[:at_signs]})                       # $2: At mark
      ([a-z0-9_]{1,20})                             # $3: Screen name
      (/[a-z][a-zA-Z0-9_-]{0,24})?                # $4: List (optional)
    }iox
    REGEXEN[:valid_reply] = /^(?:[#{UNICODE_SPACES}#{DIRECTIONAL_CHARACTERS}])*#{REGEXEN[:at_signs]}([a-z0-9_]{1,20})/io

    # Used in Extractor for final filtering
    REGEXEN[:end_mention_match] = %r{\A(?:#{REGEXEN[:at_signs]}|#{REGEXEN[:latin_accents]}|://)}io

    REGEXEN.each_pair { |_k, v| v.freeze }
    REGEXEN[:at_signs] = /[@＠]/

    REGEXEN[:list_name] = /[a-z][a-z0-9_\-\u0080-\u00ff]{0,24}/i

    # Return the regular expression for a given <tt>key</tt>. If the <tt>key</tt>
    # is not a known symbol a <tt>nil</tt> will be returned.
    def self.[](key)
      REGEXEN[key]
    end
  end
end
