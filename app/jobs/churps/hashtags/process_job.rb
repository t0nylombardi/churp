# frozen_string_literal: true

module Churps
  module Hashtags
    class ProcessJob < ApplicationJob
      queue_as :content_processors

      def perform(churp_id)
        churp = Churp.find_by(id: churp_id)
        return unless churp

        Processor.new.call(
          churp: churp,
          old_body: previous_content(churp)
        )
      end

      private

      def previous_content(churp)
        churp.saved_change_to_content&.first
      end
    end
  end
end
