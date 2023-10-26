# frozen_string_literal: true

class PrivacyPolicy < ApplicationRecord
  DEFAULT_UPDATED_AT = DateTime.new(2023, 10, 25).freeze

  def self.updated_at
    DEFAULT_UPDATED_AT.utc
  end
end
