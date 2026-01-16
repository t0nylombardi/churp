# frozen_string_literal: true

require "rails_helper"

RSpec.describe Churps::Hashtags::Types do
  describe "TagName" do
    it "accepts valid names" do
      expect(described_class::TagName["ruby_123"]).to eq("ruby_123")
    end

    it "rejects invalid names" do
      expect { described_class::TagName["ruby-rocks!"] }
        .to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe "StartIndex" do
    it "accepts zero and positive integers" do
      expect(described_class::StartIndex[0]).to eq(0)
      expect(described_class::StartIndex[5]).to eq(5)
    end

    it "rejects negative values" do
      expect { described_class::StartIndex[-1] }
        .to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe "EndIndex" do
    it "accepts positive integers" do
      expect(described_class::EndIndex[1]).to eq(1)
    end

    it "rejects non-positive values" do
      expect { described_class::EndIndex[0] }
        .to raise_error(Dry::Types::ConstraintError)
    end
  end

  describe "UsageCount" do
    it "accepts zero and positive integers" do
      expect(described_class::UsageCount[0]).to eq(0)
      expect(described_class::UsageCount[10]).to eq(10)
    end

    it "rejects negative values" do
      expect { described_class::UsageCount[-1] }
        .to raise_error(Dry::Types::ConstraintError)
    end
  end
end
