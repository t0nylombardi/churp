# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  display_name           :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer
#  sign_in_count          :integer          default(0), not null
#  slug                   :string
#  unconfirmed_email      :string
#  unlock_token           :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_display_name          (display_name)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_slug                  (slug) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
require 'rails_helper'

RSpec.describe User do
  let(:message) do
    <<-TEXT.gsub(/\s+/, ' ').strip
    Complexity requirement not met. Length is_expected.to be 8-128 characters and
    include: 1 uppercase, 1 lowercase, 1 digit and 1 special character
    TEXT
  end

  describe 'associations' do
    it { is_expected.to have_many(:churps).dependent(:destroy) }
    it { is_expected.to have_many(:likes).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:notifications).dependent(:destroy) }
    it { is_expected.to have_many(:active_relationships).dependent(:destroy).class_name('Relationship').with_foreign_key('follower_id') }
    it { is_expected.to have_many(:passive_relationships).dependent(:destroy).class_name('Relationship').with_foreign_key('followed_id') }
    it { is_expected.to have_many(:following).through(:active_relationships).source(:followed) }
    it { is_expected.to have_many(:followers).through(:passive_relationships).source(:follower) }
    it { is_expected.to have_one(:profile).dependent(:destroy) }
  end

  describe 'validations' do
    before { create(:user) }

    let(:user) { create(:user) }

    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_uniqueness_of(:username) }

    it 'is_expected.to validate email uniqueness' do
      user1 = create(:user, email: 'foo.bar@test.co')
      user2 = build(:user, email: 'foo.bar@test.co')

      expect(user1).to be_valid
      expect(user2).to_not be_valid
    end


    it 'is_expected.to validate password complexity' do
      user = build(:user, password: 'weakpassword', password_confirmation: 'weakpassword')
      expect(user).to_not be_valid

      user.password = 'Strong@Password123'
      user.password_confirmation = 'Strong@Password123'
      expect(user).to be_valid
    end

    it 'requires password on build' do
      user = build(:user, password: nil, password_confirmation: nil)

      user.valid?
      expect(user.errors.messages[:password]).to eq(["can't be blank"])
    end

    it 'does not accept a password without a confirmation' do
      user = build(:user, password: 'test_Blah1234', password_confirmation: nil)

      expect(user.valid?).to be(false)
    end

    it 'requires email addresses be in email format' do
      user = build(:user, email: 'foo')

      user.valid?
      expect(user.errors.messages[:email]).to be_present
    end

    it 'requires password and confirmation to match' do
      user = build(:user, password_confirmation: 'wtf')

      expect(user.valid?).to be(false)
    end

    it 'includes: 1 uppercase, 1 lowercase, 1 digit and 1 special character' do
      user = build(:user, password: '1234567890', password_confirmation: '1234567890')

      expect(user.valid?).to be(false)
    end

    it 'does not included: 1 uppercase, 1 lowercase, 1 digit and 1 special character' do
      user = build(:user, password: 'abcdefghijkl', password_confirmation: 'abcdefghijkl')

      expect(user.valid?).to be(false)
    end

    context 'with followers' do
      let(:rick) { create(:user) }
      let(:morty) { create(:user) }

      it 'does not follow a user' do
        expect(rick.following?(morty)).to be(false)
      end

      it 'follows a user' do
        rick.follow(morty)

        expect(rick.following?(morty)).to be(true)
      end

      it 'includes user is following user' do
        rick.follow(morty)

        expect(morty.followers.include?(rick)).to be(true)
      end

      it 'unfollows a user' do
        rick.follow(morty)
        rick.unfollow(morty)

        expect(rick.following?(morty)).to be(false)
      end
    end
  end

  describe 'before_commit' do
    let(:user) { create(:user, username: 'example') }

    it 'when set username after create' do
      expect(user.username).to eq('@example')
    end
  end

  describe 'methods' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    it 'when follow and unfollow other users' do
      expect(user.following.include?(other_user)).to be_falsey

      user.active_relationships.create(followed_id: other_user.id)
      expect(user.following.include?(other_user)).to be_truthy

      expect(user.active_relationships.find_by(followed_id: other_user.id).destroy).to be_truthy
    end

    it 'when it returns unread notifications' do
      notification = create(:notification, recipient: user, read_at: nil)
      expect(user.notifications.unread).to include(notification)
    end
  end

  describe 'callbacks' do
    it 'when set username after create' do
      user = build(:user, username: 'example')
      user.save
      expect(user.username).to eq('@example')
    end
  end
end
