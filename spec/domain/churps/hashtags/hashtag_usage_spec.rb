# frozen_string_literal: true

require "rails_helper"

RSpec.describe Churps::Hashtags::HashtagUsage do
  it "builds a valid usage object" do
    usage = described_class.new(name: "ruby", usage_count: 3)

    expect(usage.name).to eq("ruby")
    expect(usage.usage_count).to eq(3)
  end

  it "rejects negative usage counts" do
    expect { described_class.new(name: "ruby", usage_count: -1) }
      .to raise_error(Dry::Struct::Error)
  end
end
