# frozen_string_literal: true

require "rails_helper"

RSpec.describe Hashtags::Tag do
  it "builds a valid tag" do
    tag = described_class.new(name: "backend")

    expect(tag.name).to eq("backend")
  end

  it "rejects invalid tag names" do
    expect { described_class.new(name: "bad-tag!") }
      .to raise_error(Dry::Struct::Error)
  end
end
