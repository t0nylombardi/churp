# frozen_string_literal: true

module ProfileComponents
  class SocialCountComponent < ViewComponent::Base
    def initialize(count:)
      super
      @count = count
    end
  end
end
