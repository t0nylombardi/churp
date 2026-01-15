# frozen_string_literal: true

module Churps
  module Mentions
    class Mention < Dry::Struct
      transform_keys(&:to_sym)

      attribute :username, Types::Username
      attribute :start_index, Types::StartIndex
      attribute :end_index, Types::EndIndex
    end
  end
end
