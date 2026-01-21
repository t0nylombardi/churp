# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                  :uuid             not null, primary key
#  display_name        :string           default(""), not null
#  email               :string           default(""), not null
#  password_changed_at :datetime         not null
#  password_digest     :string           default(""), not null
#  role                :integer
#  slug                :string           default(""), not null
#  username            :string           default(""), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_users_on_email     (email) UNIQUE
#  index_users_on_username  (username) UNIQUE
#

require "rails_helper"

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  describe "associations" do
    it { is_expected.to have_many(:churps).dependent(:destroy) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }

    it {
      is_expected.to have_many(:churp_mentions)
        .with_foreign_key(:mentioned_user_id)
        .dependent(:destroy)
    }

    it {
      is_expected.to have_many(:mentions)
        .through(:churp_mentions)
        .source(:churp)
    }

    it {
      is_expected.to have_many(:notifications)
        .class_name("Noticed::Notification")
        .dependent(:destroy)
    }

    it {
      is_expected.to have_many(:active_relationships)
        .class_name("Relationship")
        .with_foreign_key("follower_id")
        .dependent(:destroy)
    }

    it {
      is_expected.to have_many(:passive_relationships)
        .class_name("Relationship")
        .with_foreign_key("followed_id")
        .dependent(:destroy)
    }

    it { is_expected.to have_many(:following).through(:active_relationships).source(:followed) }
    it { is_expected.to have_many(:followers).through(:passive_relationships).source(:follower) }

    it { is_expected.to have_one(:profile).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }

    context "when another user exists" do
      before { create(:user) }

      it { is_expected.to validate_uniqueness_of(:email) }
    end

    context "password complexity" do
      it "is invalid with a weak password" do
        user = build(:user, password: "weakpass", password_confirmation: "weakpass")
        user.valid?

        expect(user.errors[:password]).to be_present
      end

      it "is valid with a strong password" do
        user = build(
          :user,
          password: "Strong@Password123",
          password_confirmation: "Strong@Password123"
        )

        expect(user).to be_valid
      end
    end
  end

  describe ".normalize_login" do
    it "returns emails unchanged" do
      expect(described_class.normalize_login("user@example.com")).to eq("user@example.com")
    end

    it "prefixes @ for non-email logins" do
      expect(described_class.normalize_login("rick")).to eq("@rick")
    end
  end

  describe "#login" do
    it "returns the assigned login when present" do
      user.login = "rick@example.com"

      expect(user.login).to eq("rick@example.com")
    end

    it "falls back to username and email" do
      user.username = "@rick"
      user.email = "rick@example.com"

      expect(user.login).to eq("@rick")
    end
  end

  describe "username normalization" do
    it "prefixes @ and downcases username on create" do
      user = create(:user, username: "ExampleUser")

      expect(user.username).to eq("@exampleuser")
    end

    it "derives username from email when missing" do
      user = create(:user, username: nil, email: "Morty@example.com")

      expect(user.username).to eq("@morty")
    end
  end

  describe "#follow" do
    let(:rick) { create(:user) }
    let(:morty) { create(:user) }

    it "follows another user" do
      rick.follow(morty)

      expect(rick.following?(morty)).to be(true)
    end

    it "does not report following after unfollowing" do
      rick.follow(morty)
      rick.unfollow(morty)

      expect(rick.following?(morty)).to be(false)
    end
  end
end
