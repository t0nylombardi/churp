# frozen_string_literal: true

require "rails_helper"

RSpec.describe Churps::Hashtags::Indexer do
  describe ".call" do
    it "updates usage counts for provided tags" do
      tag = instance_double(HashTag, id: "tag-id")
      relation = instance_double(ActiveRecord::Relation)

      allow(HashTag).to receive(:where).with(id: ["tag-id"]).and_return(relation)
      allow(relation).to receive(:update_all).and_return(1)

      expect(described_class.call([tag])).to eq(1)
    end
  end
end
