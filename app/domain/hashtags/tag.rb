# frozen_string_literal: true

module Hashtags
  Types = Dry.Types()

  # Global topic representation independent of a single churp.
  class Tag < Dry::Struct
    transform_keys(&:to_sym)

    # @!attribute [r] name
    #   @return [String]
    attribute :name, Types::String.constrained(format: /\A[a-zA-Z0-9_]{1,50}\z/)
  end
end
