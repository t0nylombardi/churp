# frozen_string_literal: true

module Churps
  module Hashtags
    module Types
      include Dry.Types()

      TagName =
        Types::String
          .constructor { |v| v.downcase }
          .constrained(format: /\A[a-z0-9_]{1,50}\z/)

      StartIndex = Types::Integer.constrained(gteq: 0)
      EndIndex = Types::Integer.constrained(gt: 0)
      UsageCount = Types::Integer.constrained(gteq: 0)
    end
  end
end
