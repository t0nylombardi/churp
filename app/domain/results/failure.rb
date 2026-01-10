# frozen_string_literal: true

require_relative "result"

module Results
  class Failure < Result
    attr_reader :error

    def initialize(error)
      @error = error
    end

    def success?
      false
    end
  end
end
