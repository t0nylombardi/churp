# frozen_string_literal: true

require "rails_helper"

RSpec.describe Churps::Mentions::Mention do
  describe ".new" do
    it "accepts string keys and builds a mention" do
      mention = described_class.new(
        "username" => "alice",
        "start_index" => 0,
        "end_index" => 6
      )

      expect(mention.username).to eq("alice")
      expect(mention.start_index).to eq(0)
      expect(mention.end_index).to eq(6)
    end

    it "rejects invalid usernames" do
      expect do
        described_class.new(username: "too-long-username", start_index: 0, end_index: 6)
      end.to raise_error(Dry::Struct::Error)
    end

    it "rejects negative start indexes" do
      expect do
        described_class.new(username: "alice", start_index: -1, end_index: 6)
      end.to raise_error(Dry::Struct::Error)
    end

    it "rejects non-positive end indexes" do
      expect do
        described_class.new(username: "alice", start_index: 0, end_index: 0)
      end.to raise_error(Dry::Struct::Error)
    end
  end
end
