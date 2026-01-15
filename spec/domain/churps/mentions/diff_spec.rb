# frozen_string_literal: true

require "rails_helper"

RSpec.describe Churps::Mentions::Diff do
  describe ".call" do
    it "returns added and removed mentions based on username" do
      old_mentions = [
        Churps::Mentions::Mention.new(username: "alice", start_index: 0, end_index: 6),
        Churps::Mentions::Mention.new(username: "bob", start_index: 7, end_index: 11)
      ]
      new_mentions = [
        Churps::Mentions::Mention.new(username: "bob", start_index: 0, end_index: 4),
        Churps::Mentions::Mention.new(username: "carol", start_index: 5, end_index: 11)
      ]

      result = described_class.call(old_mentions, new_mentions)

      expect(result[:added].map(&:username)).to eq(["carol"])
      expect(result[:removed].map(&:username)).to eq(["alice"])
    end

    it "returns empty changes when mentions match" do
      mentions = [
        Churps::Mentions::Mention.new(username: "alice", start_index: 0, end_index: 6)
      ]

      result = described_class.call(mentions, mentions)

      expect(result[:added]).to eq([])
      expect(result[:removed]).to eq([])
    end
  end
end
