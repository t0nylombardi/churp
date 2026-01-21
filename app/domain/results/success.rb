# frozen_string_literal: true

require_relative "result"

module Results
  class Success < Result
    attr_reader :value

    def initialize(value = nil)
      @value = value
    end

    def success?
      true
    end
  end
end
