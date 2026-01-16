# frozen_string_literal: true

require "rails_helper"

RSpec.describe Churps::Hashtags::Persister do
  describe ".call" do
    it "creates churp hashtag associations" do
      churp = create(:churp)
      ruby = create(:hash_tag, name: "ruby")
      rails = create(:hash_tag, name: "rails")

      resolved_map = {
        "ruby" => ruby.id,
        "rails" => rails.id
      }

      expect { described_class.call(churp: churp, resolved_map: resolved_map) }
        .to change(ChurpHashTag, :count).by(2)

      expect(churp.hash_tags.reload.map(&:id)).to contain_exactly(ruby.id, rails.id)
    end

    it "does nothing when resolved_map is blank" do
      churp = create(:churp)

      expect { described_class.call(churp: churp, resolved_map: {}) }
        .not_to change(ChurpHashTag, :count)
    end
  end
end
