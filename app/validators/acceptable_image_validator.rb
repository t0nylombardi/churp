# frozen_string_literal: true

class AcceptableImageValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.attached?

    return record.errors.add(attribute, "File is too big") unless
      value.blob.byte_size <= 10.megabyte

    acceptable_types = ["image/jpeg", "image/jpg", "image/png"]

    record.errors.add(attribute, "File must be a JPEG, JPG or PNG") unless
      acceptable_types.include?(value.content_type)
  end
end
