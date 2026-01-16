# frozen_string_literal: true

require "rails_helper"

RSpec.describe Churps::Hashtags::Diff do
  describe ".call" do
    it "returns added and removed hashtags based on name" do
      old_tags = [
        Churps::Hashtags::Hashtag.new(name: "ruby", start_index: 0, end_index: 5),
        Churps::Hashtags::Hashtag.new(name: "rails", start_index: 6, end_index: 12)
      ]
      new_tags = [
        Churps::Hashtags::Hashtag.new(name: "rails", start_index: 0, end_index: 6),
        Churps::Hashtags::Hashtag.new(name: "turbo", start_index: 7, end_index: 13)
      ]

      result = described_class.call(old_tags, new_tags)

      expect(result[:added].map(&:name)).to eq(["turbo"])
      expect(result[:removed].map(&:name)).to eq(["ruby"])
    end
  end
end
