# frozen_string_literal: true

module Churps
  module Hashtags
    # Domain types used by hashtag value objects.
    #
    # These types centralize validation constraints so parsing, policy checks,
    # and persistence all rely on the same rules.
    module Types
      include Dry.Types()

      # Normalized tag name (no leading #).
      # 1-50 chars, alphanumeric or underscore.
      TagName = Types::String.constrained(format: /\A[a-zA-Z0-9_]{1,50}\z/)

      # 0-based index into a string.
      StartIndex = Types::Integer.constrained(gteq: 0)

      # End offset in a string (exclusive).
      EndIndex = Types::Integer.constrained(gt: 0)

      # Non-negative usage count for ranking and analytics.
      UsageCount = Types::Integer.constrained(gteq: 0)
    end
  end
end
