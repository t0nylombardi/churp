# frozen_string_literal: true

class ChurpLengthValidator < ActiveModel::EachValidator
  MAX_CHARS = 500

  def validate_each(record, attribute, value)
    return unless value.empty? && !record.churp_id.nil?

    record.errors.add(attribute, I18n.t('churps.over_character_limit', max: MAX_CHARS)) if too_long?(value)
  end

  private

  def too_long?(value)
    Extractor.new.sanitize(value) >= MAX_CHARS
  end
end
