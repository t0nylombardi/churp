# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
# ... [Schema unchanged for brevity] ...
#
require "rails_helper"

RSpec.describe User do
  subject(:user_instance) { described_class.new }

  let(:message) do
    <<-TEXT.gsub(/\s+/, " ").strip
      Complexity requirement not met. Length is_expected.to be 8-128 characters and
      include: 1 uppercase, 1 lowercase, 1 digit and 1 special character
    TEXT
  end

  describe "associations" do
    it { is_expected.to have_many(:churps).dependent(:destroy) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:notifications).dependent(:destroy) }

    it "has many active_relationships" do
      expect(user_instance).to have_many(:active_relationships).dependent(:destroy)
        .class_name("Relationship").with_foreign_key("follower_id")
    end

    it "has many passive_relationships" do
      expect(user_instance).to have_many(:passive_relationships).dependent(:destroy)
        .class_name("Relationship").with_foreign_key("followed_id")
    end

    it { is_expected.to have_many(:following).through(:active_relationships).source(:followed) }
    it { is_expected.to have_many(:followers).through(:passive_relationships).source(:follower) }
    it { is_expected.to have_one(:profile).dependent(:destroy) }
  end

  describe "validations" do
    before { create(:user) }

    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_uniqueness_of(:username) }

    context "when email is taken" do
      it "validates uniqueness for email" do
        create(:user, email: "foo.bar@test.co")
        user2 = build(:user, email: "foo.bar@test.co")
        expect(user2).not_to be_valid
      end
    end

    context "when password is weak" do
      it "is invalid when password is weak" do
        user = build(:user, password: "weakpassword", password_confirmation: "weakpassword")
        expect(user).not_to be_valid
      end

      it "is valid when password is strong" do
        user = build(:user, password: "Strong@Password123", password_confirmation: "Strong@Password123")
        expect(user).to be_valid
      end
    end

    it "requires password on build" do
      user = build(:user, password: nil, password_confirmation: nil)
      user.valid?
      expect(user.errors[:password]).to eq(["can't be blank"])
    end

    it "is invalid without password_confirmation" do
      user = build(:user, password: "test_Blah1234", password_confirmation: nil)
      expect(user).not_to be_valid
    end

    it "rejects non-email format for email" do
      user = build(:user, email: "foo")
      user.valid?
      expect(user.errors[:email]).to be_present
    end

    it "is invalid when confirmation doesn’t match" do
      user = build(:user, password: "test1234", password_confirmation: "nope")
      expect(user).not_to be_valid
    end

    it "requires digit/special/upper/lower chars" do
      user = build(:user, password: "1234567890", password_confirmation: "1234567890")
      expect(user).not_to be_valid
    end

    it "is invalid without special/digit/upper/lower" do
      user = build(:user, password: "abcdefghijkl", password_confirmation: "abcdefghijkl")
      expect(user).not_to be_valid
    end
  end

  describe "follower logic" do
    let(:rick) { create(:user) }
    let(:morty) { create(:user) }

    it "is not following by default" do
      expect(rick.following?(morty)).to be(false)
    end

    it "follows a user" do
      rick.follow(morty)
      expect(rick.following?(morty)).to be(true)
    end

    it "adds rick to morty's followers" do
      rick.follow(morty)
      expect(morty.followers).to include(rick)
    end

    it "unfollows a user" do
      rick.follow(morty)
      rick.unfollow(morty)
      expect(rick.following?(morty)).to be(false)
    end
  end

  describe "callbacks" do
    it "sets @username after create" do
      user = create(:user, username: "example")
      expect(user.username).to eq("@example")
    end
  end

  describe "methods" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    it "starts not following other_user" do
      expect(user.following).not_to include(other_user)
    end

    it "follows other_user" do
      user.active_relationships.create(followed_id: other_user.id)
      expect(user.following).to include(other_user)
    end

    it "unfollows other_user" do
      rel = user.active_relationships.create(followed_id: other_user.id)
      rel.destroy
      expect(user.following).not_to include(other_user)
    end

    it "returns unread notifications" do
      notification = create(:notification, recipient: user, read_at: nil)
      expect(user.notifications.unread).to include(notification)
    end
  end
end
