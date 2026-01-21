# frozen_string_literal: true

module Seed
  class BaseSeeder
    include Dry::Monads[:result, :do]

    private

    def success(value = nil)
      Success(value)
    end

    def failure(error)
      Failure(error)
    end
  end
end
