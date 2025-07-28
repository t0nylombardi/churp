# frozen_string_literal: true

module ProfileComponents
  module Buttons
    class FollowComponent < ViewComponent::Base
      def initialize(user:, profile:)
        super
        @user = user
        @profile = profile
      end

      def render?
        @user != @profile.user
      end
    end
  end
end
