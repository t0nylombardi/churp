# frozen_string_literal: true

require "rails_helper"

RSpec.describe Shared::CollectionDiff do
  describe ".call" do
    it "returns added and removed items based on a key" do
      item_class = Struct.new(:id, :name)
      old_items = [item_class.new(1, "alpha"), item_class.new(2, "beta")]
      new_items = [item_class.new(2, "beta"), item_class.new(3, "gamma")]

      result = described_class.call(old_items, new_items, key: :id)

      expect(result[:added].map(&:id)).to eq([3])
      expect(result[:removed].map(&:id)).to eq([1])
    end

    it "returns empty arrays when collections match" do
      item_class = Struct.new(:code)
      items = [item_class.new("x")]

      result = described_class.call(items, items, key: :code)

      expect(result[:added]).to eq([])
      expect(result[:removed]).to eq([])
    end
  end
end
