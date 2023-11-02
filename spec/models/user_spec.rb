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
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_slug                  (slug) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:message) do
    <<-TEXT.gsub(/\s+/, ' ').strip
    Complexity requirement not met. Length should be 8-128 characters and
    include: 1 uppercase, 1 lowercase, 1 digit and 1 special character
    TEXT
  end

  describe 'validations' do

    it 'requires password on build' do
      user = FactoryBot.build(:user, password: nil, password_confirmation: nil)

      user.valid?
      expect(user.errors.messages[:password]).to eq(["can't be blank"])
    end

    it 'does not accept a password without a confirmation' do
      user = FactoryBot.build(:user, password: 'test_Blah1234', password_confirmation: nil)

      user.valid?
    end

    it 'requires email addresses be in email format' do
      user = FactoryBot.build(:user, email: 'foo')

      user.valid?
      expect(user.errors.messages[:email]).to be_present
    end

    it 'requires password and confirmation to match' do
      user = FactoryBot.build(:user, password_confirmation: 'wtf')

      user.valid?
      expect(user.errors.messages[:password_confirmation]).to eq(["doesn't match Password"])
    end

    it 'requires at least 10 characters for the password' do
      user = FactoryBot.build(:user, password: 'hi1', password_confirmation: 'hi1')

      user.valid?
      expect(user.errors.full_messages).to eq(['Password is too short (minimum is 10 characters)', "Password #{message}"])
    end

    it 'includes: 1 uppercase, 1 lowercase, 1 digit and 1 special character' do
      user = FactoryBot.build(:user, password: '1234567890', password_confirmation: '1234567890')

      user.valid?
      expect(user.errors.messages[:password]).to eq([message])
    end

    it 'does not included: 1 uppercase, 1 lowercase, 1 digit and 1 special character' do
      user = FactoryBot.build(:user, password: 'abcdefghijkl', password_confirmation: 'abcdefghijkl')

      user.valid?
      expect(user.errors.messages[:password]).to eq([message])
    end

    context 'with followers' do
      let(:rick) { FactoryBot.create(:user) }
      let(:morty) { FactoryBot.create(:user) }

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
end
