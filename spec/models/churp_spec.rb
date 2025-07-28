# frozen_string_literal: true

# == Schema Information
#
# Table name: churps
#
#  id            :bigint           not null, primary key
#  body          :text
#  rechurp_count :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  churp_id      :integer
#  user_id       :bigint           not null
#
# Indexes
#
#  index_churps_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require "rails_helper"

RSpec.describe Churp do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:churp).optional.dependent(:destroy) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:churp_hash_tags).dependent(:destroy) }
    it { is_expected.to have_many(:hash_tags).through(:churp_hash_tags).dependent(:destroy) }
    it { is_expected.to have_many(:notifications).dependent(:destroy) }
    it { is_expected.to have_rich_text(:content) }
    it { is_expected.to have_one_attached(:churp_pic) }
  end

  describe "callbacks" do
    it { is_expected.to callback(:create_hash_tags).after(:create) }
    it { is_expected.to callback(:broadcast_churp).after(:create) }
    it { is_expected.to callback(:broadcast_notifications).after(:commit) }
  end

  describe "scopes" do
    describe ".search_hashtags" do
      let!(:churp_with_hashtag) { create(:churp, content: "This is a #test churp") }
      let!(:churp_without_hashtag) { create(:churp, content: "This is a churp without hashtags") }

      it "includes churps with the hashtag" do
        result = described_class.search_hashtags("test")
        expect(result).to include(churp_with_hashtag)
      end

      it "excludes churps without the hashtag" do
        result = described_class.search_hashtags("test")
        expect(result).not_to include(churp_without_hashtag)
      end
    end
  end

  describe "#churp_type" do
    it 'returns "rechurp" if churp_id and content are present' do
      churp = create(:churp, churp_id: 1, content: "This is a churp")
      expect(churp.churp_type).to eq("rechurp")
    end

    it 'returns "churp" if churp_id is nil' do
      churp = build(:churp, churp_id: nil, content: "This is a churp")
      expect(churp.churp_type).to eq("churp")
    end

    it 'returns "churp" if content is nil' do
      churp = build(:churp, churp_id: 1, content: nil)
      expect(churp.churp_type).to eq("churp")
    end
  end

  describe "#create_hash_tags" do
    it "creates a hashtag from content" do
      churp = build(:churp, content: "This is a #test churp")
      expect { churp.save }.to change(HashTag, :count).by(1)
    end
  end

  describe "#extract_name_hash_tags" do
    it "returns tag names from content" do
      churp = build(:churp, content: "This is a #test churp")
      expect(churp.extract_name_hash_tags).to eq(["test"])
    end
  end

  describe "#create validations" do
    let(:user) { create(:user) }
    let(:churp) { create(:churp, user:) }

    it "is invalid with empty content" do
      churp.content = ""
      expect(churp).not_to be_valid
    end

    # 👇 One allowed multi-expectation example
    it "is invalid when content is too long (exempted)" do
      churp1 = build(:churp, content: Faker::Lorem.paragraph_by_chars(number: 502))

      expect(churp1.errors.messages[:content]).to eq(["content is too long (maximum is 331 characters)"])
    end

    it "is invalid without a user" do
      churp.user = nil
      expect(churp).not_to be_valid
    end

    it "returns user must exist error" do
      churp.user = nil
      churp.valid?
      expect(churp.errors.messages[:user]).to eq(["must exist"])
    end

    context "with attached media" do
      it "is valid with a supported image" do
        churp = create(:churp, :with_attachment)
        expect(churp.valid?).to be true
      end

      it "is invalid with non-image file" do # standard:disable RSpec/ExampleLength
        churp.churp_pic.attach(
          io: Rails.root.join("spec/fixtures/images/wrong_file.txt").open,
          filename: "wrong_file.txt",
          content_type: "application/txt"
        )
        expect(churp.errors[:churp_pic]).to eq(["File must be a JPEG, JPG or PNG"])
      end
    end
  end
end
