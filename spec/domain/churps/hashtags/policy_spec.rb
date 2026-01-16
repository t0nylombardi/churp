# frozen_string_literal: true

require "rails_helper"

RSpec.describe Churps::Hashtags::Policy do
  describe ".allowed?" do
    it "returns true for the default policy" do
      churp = build(:churp)

      expect(described_class.allowed?(churp: churp, name: "ruby")).to eq(true)
    end
  end
end
