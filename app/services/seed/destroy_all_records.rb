# frozen_string_literal: true

module Seed
  class DestroyAllRecords < BaseSeeder
    MODELS = [
      ChurpHashTag,
      HashTag,
      Like,
      Profile,
      Churp,
      User
    ].freeze

    def call
      MODELS.each do |model|
        Rails.logger.info "Destroying all records for #{model.name}..."
        model.destroy_all
        success("#{model.name} records destroyed")
      end

      success("All records destroyed")
    rescue ActiveRecord::ActiveRecordError => e
      failure(e)
    end
  end
end
