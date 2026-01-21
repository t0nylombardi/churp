# frozen_string_literal: true

require "rails_helper"

RSpec.describe Churps::Hashtags::Policy do
  describe ".allowed?" do
    let_it_be(:churp) { build(:churp) }
    it "returns true for the default policy" do
      expect(described_class.allowed?(churp: churp, name: "ruby")).to eq(true)
    end
  end
end
