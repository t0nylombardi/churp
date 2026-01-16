# frozen_string_literal: true

require "rails_helper"

RSpec.describe Churps::Hashtags::Hashtag do
  it "builds a valid hashtag" do
    hashtag = described_class.new(name: "rails", start_index: 0, end_index: 6)

    expect(hashtag.name).to eq("rails")
    expect(hashtag.start_index).to eq(0)
    expect(hashtag.end_index).to eq(6)
  end

  it "rejects invalid tag names" do
    expect {
      described_class.new(name: "bad-tag!", start_index: 0, end_index: 4)
    }.to raise_error(Dry::Types::ConstraintError)
  end
end
