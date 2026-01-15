# frozen_string_literal: true

require "rails_helper"

RSpec.describe Churps::Mentions::Parser do
  describe ".call" do
    it "returns empty array for blank text" do
      expect(described_class.call(nil)).to eq([])
      expect(described_class.call("   ")).to eq([])
    end

    it "extracts unique mentions with indexes" do
      text = "@alice hi @bob"

      mentions = described_class.call(text)

      expect(mentions.map(&:username)).to eq(%w[alice bob])
      expect(mentions.map(&:start_index)).to eq([0, 10])
      expect(mentions.map(&:end_index)).to eq([6, 14])
    end

    it "deduplicates mentions by username" do
      mentions = described_class.call("@alice @alice")

      expect(mentions.map(&:username)).to eq(["alice"])
      expect(mentions.first.start_index).to eq(0)
    end

    it "ignores mentions embedded in words" do
      text = "email me at test@example.com and say hi to @bob"

      mentions = described_class.call(text)

      expect(mentions.map(&:username)).to eq(["bob"])
    end
  end
end
