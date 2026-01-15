# frozen_string_literal: true

module Churps
  module Mentions
    module Types
      include Dry.Types()

      Username = Types::String
        .constrained(format: /\A[a-zA-Z0-9_]{1,15}\z/)

      StartIndex = Types::Integer.constrained(gteq: 0)
      EndIndex = Types::Integer.constrained(gt: 0)
    end
  end
end
