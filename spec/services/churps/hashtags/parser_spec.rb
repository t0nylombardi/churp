# frozen_string_literal: true

require "rails_helper"

RSpec.describe Churps::Hashtags::Parser do
  describe ".call" do
    it "returns empty array for blank text" do
      expect(described_class.call(nil)).to eq([])
      expect(described_class.call("   ")).to eq([])
    end

    it "extracts unique hashtags with indexes" do
      text = "#Ruby is great #Rails"

      hashtags = described_class.call(text)

      expect(hashtags.map(&:name)).to eq(%w[ruby rails])
      expect(hashtags.map(&:start_index)).to eq([0, 15])
      expect(hashtags.map(&:end_index)).to eq([5, 21])
    end

    it "deduplicates hashtags by name" do
      hashtags = described_class.call("#ruby #ruby")

      expect(hashtags.map(&:name)).to eq(["ruby"])
      expect(hashtags.first.start_index).to eq(0)
    end

    it "ignores hashtags embedded in words" do
      text = "email#notatag and #real_tag"

      hashtags = described_class.call(text)

      expect(hashtags.map(&:name)).to eq(["real_tag"])
    end
  end
end
