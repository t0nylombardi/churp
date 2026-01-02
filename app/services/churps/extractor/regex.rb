# frozen_string_literal: true

module Churps
  module Extractor
    ##
    # == Churps::Extractor::Regex
    #
    # Public thread-safe singleton facade for accessing compiled regex patterns.
    # Delegates to {Churps::Extractor::RegexBuilder} internally.
    #
    # @example
    #   Churps::Extractor::Regex[:valid_mention_or_list]
    #
    class Regex
      @mutex = Mutex.new

      class << self
        def [](key)
          builder.pattern_for(key)
        end

        private

        def builder
          @mutex.synchronize do
            @builder ||= RegexBuilder.new
          end
        end
      end
    end
  end
end
