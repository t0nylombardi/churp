# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::UsernameNormalizer do
  describe ".call" do
    it "uses provided username" do
      result = described_class.call(username: "Tony", email: nil)

      expect(result).to be_success
      expect(result.value!.to_s).to eq("@tony")
    end

    it "derives username from email" do
      result = described_class.call(
        username: nil,
        email: "t0ny@email.com"
      )

      expect(result.value!.to_s).to eq("@t0ny")
    end

    it "normalizes invalid characters" do
      result = described_class.call(
        username: "t0ny.two-taps",
        email: nil
      )

      expect(result.value!.to_s).to eq("@t0ny_two_taps")
    end
  end
end
