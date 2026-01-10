# frozen_string_literal: true

class ChurpLengthValidator < ActiveModel::EachValidator
  MAX_CHARS = 331

  def validate_each(record, attribute, _value)
    record.errors.add(attribute, I18n.t("churps.cannot_be_empty")) if empty?(record)
    record.errors.add(attribute, I18n.t("churps.under_character_limit", min: 1)) if too_short?(record)
    record.errors.add(attribute, I18n.t("churps.over_character_limit", max: MAX_CHARS)) if too_long?(record)
  end

  private

  def empty?(record)
    record.content.to_s.strip.empty?
  end

  def too_short?(record)
    record.content.to_s.strip.length < 1
  end

  def too_long?(record)
    record.content.to_s.strip.length > MAX_CHARS
  end
end
