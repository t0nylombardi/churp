# frozen_string_literal: true

module Churps
  module Mentions
    class ResolvedMention < Dry::Struct
      attribute :mention, Mention
      attribute :mentioned_user_id, Dry::Types["string"]
    end
  end
end
