# frozen_string_literal: true

class ChurpLengthValidator < ActiveModel::EachValidator
  MAX_CHARS = 500

  def validate_each(record, attribute, value)
    return unless value.empty? && !record.churp_id.nil?

    record.errors.add(attribute, I18n.t('churps.over_character_limit', max: MAX_CHARS)) if too_long?(value)
  end

  private

  def too_long?(value)
    strip_whitespace(strip_html(value)) >= MAX_CHARS
  end

  def strip_html(value)
    ActionView::Base.full_sanitizer.sanitize(value)
  end

  def strip_whitespace(value)
    value.strip
  end
end
