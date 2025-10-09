# frozen_string_literal: true

class ChurpLengthValidator < ActiveModel::EachValidator
  MAX_CHARS = 331

  def validate_each(record, attribute, _value)
    # binding.pry
    record.errors.add(attribute, I18n.t("churps.cannot_be_empty")) if empty?(record)
    record.errors.add(attribute, I18n.t("churps.under_character_limit", min: 1)) if too_short?(record)
    record.errors.add(attribute, I18n.t("churps.over_character_limit", max: MAX_CHARS)) if too_long?(record)
  end

  private

  def extract_text(record)
    ChurpExtractor::Extractor.new.sanitize(record.body.body.to_s)
  end

  def empty?(record)
    extract_text(record).strip.empty?
  end

  def too_short?(record)
    extract_text(record).length <= 1
  end

  def too_long?(record)
    extract_text(record).length > MAX_CHARS
  end
end
