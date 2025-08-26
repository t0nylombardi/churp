module ChurpExtractor
  class Regex
    require "yaml"

    REGEXEN = begin
      regexen = {}

      # UNICODE_SPACES...
      UNICODE_SPACES = [
        (0x0009..0x000D).to_a,
        0x0020, 0x0085, 0x00A0, 0x1680, 0x180E,
        (0x2000..0x200A).to_a, 0x2028, 0x2029,
        0x202F, 0x205F, 0x3000
      ].flatten.map { |c| [c].pack("U*") }.freeze

      regexen[:spaces] = /[#{UNICODE_SPACES.join}]/o

      # Directionals...
      DIRECTIONAL_CHARACTERS = [
        0x061C, 0x200E, 0x200F, 0x202A, 0x202B, 0x202C,
        0x202D, 0x202E, 0x2066, 0x2067, 0x2068, 0x2069
      ].map { |cp| [cp].pack("U") }.freeze

      regexen[:directional_characters] = /[#{DIRECTIONAL_CHARACTERS.join}]/o

      regexen[:valid_mention_preceding_chars] = /(?:[^a-z0-9_!#$%&*@＠]|^|(?:^|[^a-z0-9_+~.-])[rR][tT]:?)/io
      regexen[:at_signs] = /[@＠]/

      regexen[:valid_mention_or_list] = %r{
        (#{regexen[:valid_mention_preceding_chars]})
        (#{regexen[:at_signs]})
        ([a-z0-9_]{1,20})
        (/[a-z][a-zA-Z0-9_-]{0,24})?
      }iox

      regexen[:valid_reply] = /
        ^
        (?:
          [#{UNICODE_SPACES.join} #Unicodewhtspar#{DIRECTIONAL_CHARACTERS.join}]
        )*
        #{regexen[:at_signs]}
        ([a-z0-9_]{1,20})
      /xio

      regexen[:end_mention_match] = %r{\A(?:#{regexen[:at_signs]}|://)}io
      regexen[:list_name] = /[a-z][a-z0-9_\-\u0080-\u00ff]{0,24}/i

      regexen.each_value(&:freeze)
      regexen.freeze
    end

    def self.[](key)
      REGEXEN[key]
    end
  end
end
