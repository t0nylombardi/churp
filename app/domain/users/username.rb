# frozen_string_literal: true

module Users
  # Value object representing a normalized username.
  #
  # This object guarantees:
  # - lowercase
  # - prefixed with "@"
  # - valid character set
  #
  # It does NOT guarantee uniqueness.
  class Username
    attr_reader :value

    # @param value [String]
    def initialize(value:)
      @value = Types::Username[value]
    end

    def to_s
      value
    end

    def ==(other)
      other.is_a?(Username) && other.value == value
    end
  end
end
