# frozen_string_literal: true

module ProfileComponents
  class SocialCountComponent < ViewComponent::Base
    def initialize(count:)
      @count = count
    end
  end
end
