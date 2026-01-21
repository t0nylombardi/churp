# frozen_string_literal: true

module Shared
  # Computes added/removed items using a stable key.
  #
  # This helper is intentionally generic and side-effect free. It is meant for
  # small to medium collections in application memory (not database-level diffs).
  class CollectionDiff
    # Builds a diff hash keyed by :added and :removed.
    #
    # @param old_items [Array<Object>] previously stored items
    # @param new_items [Array<Object>] newly parsed or requested items
    # @param key [Symbol] method name used to compare items (e.g. :username)
    # @return [Hash{Symbol=>Array<Object>}] diff hash with :added and :removed keys
    def self.call(old_items, new_items, key:)
      old_keys = old_items.map(&key)
      new_keys = new_items.map(&key)

      {
        added: new_items.reject { |item| old_keys.include?(item.public_send(key)) },
        removed: old_items.reject { |item| new_keys.include?(item.public_send(key)) }
      }
    end
  end
end
