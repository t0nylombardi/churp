# frozen_string_literal: true

module Churps
  module Mentions
    class Mention < Dry::Struct
      transform_keys(&:to_sym)

      attribute :username, Dry::Types["string"].constrained(min_size: 1)
      attribute :start_index, Dry::Types["integer"].constrained(gteq: 0)
      attribute :end_index, Dry::Types["integer"].constrained(gt: :start_index)
    end
  end
end
