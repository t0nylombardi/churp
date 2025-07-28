# frozen_string_literal: true

module ChurpComponents
  class UserLinkComponent < ViewComponent::Base
    attr_reader :churp

    def initialize(churp:)
      super
      @churp = churp
    end

    def time_created_at
      time = "#{distance_of_time_in_words(@churp.created_at.to_i - Time.now.to_i)} ago"

      time.gsub(/^about /, '')
    end
  end
end
