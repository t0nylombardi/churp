# frozen_string_literal: true

# == Schema Information
#
# Table name: churps
#
#  id                :uuid             not null, primary key
#  content           :jsonb            not null
#  rechurps_count    :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  original_churp_id :uuid
#  user_id           :uuid             not null
#
# Indexes
#
#  index_churps_on_original_churp_id  (original_churp_id)
#  index_churps_on_user_id            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (original_churp_id => churps.id)
#  fk_rails_...  (user_id => users.id)
#

require "rails_helper"

RSpec.describe Churp, type: :model do
  include ActiveJob::TestHelper

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:original_churp).class_name("Churp").optional }
    it { is_expected.to have_many(:rechurps).class_name("Churp").with_foreign_key(:original_churp_id).dependent(:destroy) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:churp_hash_tags).dependent(:destroy) }
    it { is_expected.to have_many(:hash_tags).through(:churp_hash_tags) }
    it { is_expected.to have_many(:noticed_events).class_name("Noticed::Event").dependent(:destroy) }
    it { is_expected.to have_many(:notifications).through(:noticed_events).class_name("Noticed::Notification") }
  end

  describe "validations" do
    let(:content) do
      {
        "version" => 1,
        "blocks" => [{ "type" => "text", "content" => "hello world" }]
      }
    end

    it "is valid with structured content" do
      expect(build(:churp, content:)).to be_valid
    end

    it "is invalid without content" do
      churp = build(:churp, content: nil)

      expect(churp).not_to be_valid
      expect(churp.errors[:content]).to be_present
    end

    it "is invalid when content is not structured" do
      churp = build(:churp, content: { "version" => 1 })
      churp.valid?

      expect(churp.errors[:content]).to include("must be a versioned structured content document")
    end
  end

  describe "scopes" do
    describe ".search_hashtags" do
      let(:hash_tag) { create(:hash_tag, name: "test") }
      let!(:churp_with_tag) { create(:churp) }
      let!(:churp_without_tag) { create(:churp) }

      before do
        create(:churp_hash_tag, churp: churp_with_tag, hash_tag:)
      end

      it "includes churps tagged with the query" do
        expect(described_class.search_hashtags("test")).to include(churp_with_tag)
      end

      it "excludes churps without the tag" do
        expect(described_class.search_hashtags("test")).not_to include(churp_without_tag)
      end
    end
  end

  describe "#rechurp?" do
    it "returns true when original_churp is present" do
      original = create(:churp)
      rechurp = build(:churp, original_churp: original)

      expect(rechurp.rechurp?).to be(true)
    end

    it "returns false when original_churp is nil" do
      churp = build(:churp, original_churp: nil)

      expect(churp.rechurp?).to be(false)
    end
  end

  describe "#churp_type" do
    it "returns rechurp for rechurps" do
      original = create(:churp)
      rechurp = build(:churp, original_churp: original)

      expect(rechurp.churp_type).to eq("rechurp")
    end

    it "returns churp for original churps" do
      churp = build(:churp, original_churp: nil)

      expect(churp.churp_type).to eq("churp")
    end
  end

  describe "ActiveJob" do
    it "enqueues hashtag and mention jobs on create" do
      expect {
        create(:churp)
      }.to have_enqueued_job(Churps::Hashtags::ProcessJob)
        .and have_enqueued_job(Churps::Mentions::ProcessJob)
    end
  end
end
