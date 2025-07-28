# frozen_string_literal: true

require "rails_helper"

describe ChurpExtractor::Regex do
  describe "matching List names" do
    it "is less than 25 characters" do
      name = "Shuffleboard Community"
      expect(name.length).to be < 25
    end

    it "matches the list_name regex if less than 25 characters" do
      name = "Shuffleboard Community"
      expect(name).to match(ChurpExtractor::Regex::REGEXEN[:list_name])
    end

    it "is greater than 25 characters" do
      name = "Most Glorious Shady Meadows Shuffleboard Community"
      expect(name.length).to be > 25
    end

    it "matches the list_name regex if greater than 25 characters" do
      name = "Most Glorious Shady Meadows Shuffleboard Community"
      expect(name).to match(described_class[:list_name])
    end
  end
end
