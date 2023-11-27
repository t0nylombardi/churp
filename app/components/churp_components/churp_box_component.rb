# frozen_string_literal: true

module ChurpComponents
  class ChurpBoxComponent < ViewComponent::Base
    def initialize(churp:)
      super
      @churp = churp
    end
  end
end
