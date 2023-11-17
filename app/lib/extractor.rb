# frozen_string_literal: true

class Extractor
  include Twitter::TwitterText::Extractor

  attr_reader :text

  def initialize(text: String)
    @text = text
  end

  def extract_usernames(text)
    extract_mentioned_screen_names(sanitize(text)).uniq
  end

  def sanitize(text)
    ActionView::Base.full_sanitizer.sanitize(text).strip
  end
end
