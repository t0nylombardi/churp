# frozen_string_literal: true

require "rails_helper"

RSpec.describe Churps::Hashtags::Resolver do
  describe ".call" do
    it "returns a name to tag map, creating missing tags" do
      existing = create(:hash_tag, name: "ruby")
      hashtags = [
        Churps::Hashtags::Hashtag.new(name: "ruby", start_index: 0, end_index: 5),
        Churps::Hashtags::Hashtag.new(name: "rails", start_index: 6, end_index: 12)
      ]

      result = nil
      expect { result = described_class.call(hashtags) }.to change(HashTag, :count).by(1)

      expect(result.keys).to contain_exactly("ruby", "rails")
      expect(result["ruby"].id).to eq(existing.id)
      expect(result["rails"]).to be_a(HashTag)
    end
  end
end
