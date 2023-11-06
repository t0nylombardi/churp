# frozen_string_literal: true

module ProfileComponents
  module Buttons
    class EditComponent < ViewComponent::Base
      def initialize(user:, profile:)
        super
        @user = user
        @profile = profile
      end

      def render?
        @user.id == @profile&.user&.id
      end
    end
  end
end
