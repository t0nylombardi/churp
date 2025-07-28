# frozen_string_literal: true

class ChurpLengthValidator < ActiveModel::EachValidator
  MAX_CHARS = 331

  def validate_each(record, attribute, _value)
    # return unless record.content.body.empty?

    record.errors.add(attribute, I18n.t('churps.under_character_limit', min: 1)) if too_short?(record)
    record.errors.add(attribute, I18n.t('churps.over_character_limit', max: MAX_CHARS)) if too_long?(record)
  end

  private

  def too_short?(record)
    ChurpExtractor::Extractor.new.sanitize(record.content.body.to_s).length <= 0
  end

  def too_long?(record)
    ChurpExtractor::Extractor.new.sanitize(record.content.body.to_s).length > MAX_CHARS
  end
end
