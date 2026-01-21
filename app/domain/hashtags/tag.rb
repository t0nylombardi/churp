# frozen_string_literal: true

module Hashtags
  # Centralized types for the global tag namespace.
  Types = Dry.Types()

  # Global topic representation independent of a single churp.
  #
  # This object is intentionally lightweight and free of persistence concerns.
  class Tag < Dry::Struct
    transform_keys(&:to_sym)

    # @!attribute [r] name
    #   Normalized tag name (no # prefix).
    #   @return [String]
    attribute :name, Types::String.constrained(format: /\A[a-zA-Z0-9_]{1,50}\z/)
  end
end
