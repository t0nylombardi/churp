# frozen_string_literal: true

# == Schema Information
#
# Table name: profiles
#
#  id          :bigint           not null, primary key
#  birth_date  :datetime
#  description :text
#  first_name  :string
#  last_name   :string
#  theme       :integer          default(0)
#  theme_color :integer          default(0)
#  website     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require "rails_helper"

RSpec.describe Profile do
  let(:user) { build(:user) }

  describe "#create" do
    context "when field attrs are valid" do
      it "saves first_name correctly" do
        create(:profile, first_name: "Rick")
        expect(described_class.last.first_name).to eq "Rick"
      end

      it "saves last_name correctly" do
        create(:profile, last_name: "Sanchez")
        expect(described_class.last.last_name).to eq "Sanchez"
      end

      it "saves description correctly" do
        create(:profile, description: "I love tacos and tacos loves me")
        expect(described_class.last.description).to eq "I love tacos and tacos loves me"
      end

      it "saves website correctly" do
        create(:profile, website: "http://test.test.com")
        expect(described_class.last.website).to eq "http://test.test.com"
      end
    end

    context "with invalid description" do
      it "is not valid when too long" do
        profile = build(:profile, description: Faker::Lorem.characters(number: 302), user:)
        expect(profile).not_to be_valid
      end

      it "adds length error to description" do
        profile = build(:profile, description: Faker::Lorem.characters(number: 302), user:)
        profile.valid?
        expect(profile.errors[:description]).to eq(["is too long (maximum is 300 characters)"])
      end
    end

    context "with invalid website" do
      it "is not valid when too long" do
        profile = build(:profile, website: Faker::Lorem.characters(number: 256), user:)
        expect(profile).not_to be_valid
      end

      it "adds length error to website" do
        profile = build(:profile, website: Faker::Lorem.characters(number: 256), user:)
        profile.valid?
        expect(profile.errors[:website]).to eq(["is too long (maximum is 255 characters)"])
      end
    end
  end

  describe "Upload profile_bg" do
    subject(:attachment) { create(:profile, user:).profile_bg }

    let(:image_path) { Rails.root.join("spec/fixtures/images") }
    let(:image_params) { { content_type: "image/jpeg" } }
    let(:profile) { create(:profile, user:) }

    it "is an ActiveStorage::Attached::One" do
      expect(attachment).to be_an_instance_of(ActiveStorage::Attached::One)
    end

    it "attaches profile_bg successfully" do
      file = File.open(image_path.join("stanley-roper-profile.png"))
      profile.profile_bg.attach(image_params.merge(io: file, filename: "stanley-roper-profile.png"))
      expect(profile.profile_bg).to be_attached
    end

    it "is valid after profile_bg is attached" do
      file = File.open(image_path.join("stanley-roper-profile.png"))
      profile.profile_bg.attach(image_params.merge(io: file, filename: "stanley-roper-profile.png"))
      expect(profile).to be_valid
    end

    context "with validations" do
      it "errors on file size too large" do
        file = File.open(image_path.join("big_file.jpg"))
        profile.profile_bg.attach(image_params.merge(io: file, filename: "big_file.jpg"))
        expect(profile.errors[:profile_bg]).to eq(["File is too big"])
      end

      it "errors on invalid file type" do
        file = File.open(image_path.join("wrong_file.txt"))
        profile.profile_bg.attach(image_params.merge(io: file, filename: "wrong_file.txt", content_type: "application/txt"))
        expect(profile.errors[:profile_bg]).to eq(["File must be a JPEG, JPG or PNG"])
      end
    end
  end

  describe "Upload profile_pic" do
    subject(:attachment) { create(:profile, user:).profile_pic }

    let(:profile) { create(:profile, user:) }
    let(:image_path) { Rails.root.join("spec/fixtures/images") }
    let(:params) do
      {
        io: File.open(image_path.join("stanley-roper-profile.png")),
        filename: "stanley-roper-profile.png",
        content_type: "image/png"
      }
    end

    it "is an ActiveStorage::Attached::One" do
      expect(attachment).to be_an_instance_of(ActiveStorage::Attached::One)
    end

    it "attaches profile_pic successfully" do
      profile.profile_pic.attach(params)
      expect(profile.profile_pic).to be_attached
    end

    it "is valid after profile_pic is attached" do
      profile.profile_pic.attach(params)
      expect(profile).to be_valid
    end

    context "with validations" do
      let(:params) do
        {
          filename: "stanley-roper-profile.png",
          content_type: "image/png"
        }
      end

      it "is not valid when file is too large" do
        file = File.open(image_path.join("big_file.jpg"))
        profile.profile_pic.attach(params.merge(io: file, filename: "big_file.jpg"))
        expect(profile).not_to be_valid
      end

      it "adds error for file size" do
        file = File.open(image_path.join("big_file.jpg"))
        profile.profile_pic.attach(params.merge(io: file, filename: "big_file.jpg"))
        expect(profile.errors[:profile_pic]).to eq(["File is too big"])
      end

      it "adds error for invalid file type" do
        file = File.open(image_path.join("wrong_file.txt"))
        profile.profile_pic.attach(params.merge(io: file, filename: "wrong_file.txt", content_type: "application/txt"))
        expect(profile.errors[:profile_pic]).to eq(["File must be a JPEG, JPG or PNG"])
      end
    end
  end
end
