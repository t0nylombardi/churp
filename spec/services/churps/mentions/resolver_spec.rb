# frozen_string_literal: true

require "rails_helper"

RSpec.describe Churps::Mentions::Resolver do
  describe ".call" do
    it "returns a username to id map for existing users" do
      alice = create(:user, username: "alice")
      bob = create(:user, username: "bob")

      mentions = [
        Churps::Mentions::Mention.new(username: "@alice", start_index: 0, end_index: 6),
        Churps::Mentions::Mention.new(username: "@bob", start_index: 7, end_index: 11),
        Churps::Mentions::Mention.new(username: "@missing", start_index: 12, end_index: 20)
      ]

      result = described_class.call(mentions)

      expect(result).to eq(
        "@alice" => alice.id,
        "@bob" => bob.id
      )
    end
  end
end
