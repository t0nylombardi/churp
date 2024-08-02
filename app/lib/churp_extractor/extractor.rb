# frozen_string_literal: true

module ChurpExtractor
  class Extractor
    require 'English'
    attr_reader :text

    # Extracts a list of all usernames mentioned in the Tweet <tt>text</tt>. If the
    # <tt>text</tt> is <tt>nil</tt> or contains no username mentions an empty array
    # will be returned.
    def extract_mentioned_screen_names(text)
      extract_mentioned_screen_names_with_indices(text).pluck(:screen_name)
    end

    # Extracts a list of all usernames mentioned in the Tweet <tt>text</tt>
    # along with the indices for where the mention ocurred.  If the
    # <tt>text</tt> is nil or contains no username mentions, an empty array
    # will be returned.
    #
    # If a block is given, then it will be called with each username, the start
    # index, and the end index in the <tt>text</tt>.
    def extract_mentioned_screen_names_with_indices(text) # :yields: username, start, end
      return [] unless text

      possible_screen_names = []
      extract_mentions_or_lists_with_indices(text) do |screen_name, start_position, end_position|
        possible_screen_names << {
          screen_name:,
          indices: [start_position, end_position]
        }
      end

      possible_screen_names
    end

    # Extracts a list of all usernames or lists mentioned in the Tweet <tt>text</tt>
    # along with the indices for where the mention ocurred.  If the
    # <tt>text</tt> is nil or contains no username or list mentions, an empty array
    # will be returned.
    #
    # If a block is given, then it will be called with each username, list slug, the start
    # index, and the end index in the <tt>text</tt>. The list_slug will be an empty stirng
    # if this is a username mention.
    def extract_mentions_or_lists_with_indices(text) # :yields: username, list_slug, start, end
      return [] unless text.match?(ChurpExtractor::Regex[:at_signs])

      possible_entries = []
      text.scan(ChurpExtractor::Regex[:valid_mention_or_list]) do |_before, _at, screen_name, list_slug|
        match_data = $LAST_MATCH_INFO
        after = ::Regexp.last_match.post_match

        possible_entries << entries(match_data, after, screen_name, list_slug)
      end

      possible_entries.each { |m| yield m[:screen_name], m[:indices].first, m[:indices].last } if block_given?

      possible_entries
    end

    def entries(match_data, after, screen_name, list_slug)
      return unless after.match?(ChurpExtractor::Regex[:end_mention_match])

      start_position = match_data.begin(3) - 1
      end_position = match_data.end(list_slug.nil? ? 3 : 4)
      {
        screen_name:,
        indices: [start_position, end_position]
      }
    end

    def sanitize(string)
      sanitized_str = ActionView::Base.full_sanitizer.sanitize(string)
      sanitized_str.strip
    end
  end
end
