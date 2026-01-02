# frozen_string_literal: true

module ChurpComponents
  class ChurpBoxComponent < ViewComponent::Base
    def initialize(churp:)
      @churp = churp
    end
  end
end
