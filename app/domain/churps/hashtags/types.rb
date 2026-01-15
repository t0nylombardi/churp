# frozen_string_literal: true

module Churps
  module Hashtags
    # Domain types used by hashtag value objects.
    module Types
      include Dry.Types()

      TagName = Types::String.constrained(format: /\A[a-zA-Z0-9_]{1,50}\z/)
      StartIndex = Types::Integer.constrained(gteq: 0)
      EndIndex = Types::Integer.constrained(gt: 0)
      UsageCount = Types::Integer.constrained(gteq: 0)
    end
  end
end
