# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:message) do
    <<-TEXT.gsub(/\s+/, ' ').strip
    Complexity requirement not met. Length should be 8-128 characters and
    include: 1 uppercase, 1 lowercase, 1 digit and 1 special character
    TEXT
  end

  describe 'create' do
    before :each do
      @user = User.new(FactoryBot.attributes_for(:user))
      expect(@user.valid?).to be_truthy
    end

    it 'should require password on create' do
      @user.password = nil
      @user.password_confirmation = nil

      expect(@user.valid?).to be_falsey
      expect(@user.errors.messages[:password]).to eq(["can't be blank"])
    end

    it 'should not accept a password without a confirmation' do
      @user.password = 'test_Blah1234'
      @user.password_confirmation = nil

      expect(@user.valid?).to be_falsey
    end

    it 'should require email addresses be in email format' do
      @user.email = 'foo'
      expect(@user.valid?).to be_falsey

      expect(@user.errors.messages[:email]).to be_present
    end

    it 'should require password and confirmation to match' do
      @user.password_confirmation = 'wtf'
      expect(@user.valid?).to be_falsey

      expect(@user.errors.messages[:password_confirmation]).to eq(["doesn't match Password"])
    end

    it 'should require at least 10 characters for the password' do
      @user.password = 'hi1'
      @user.password_confirmation = 'hi1'

      expect(@user.valid?).to be_falsey
      expect(@user.errors.full_messages).to eq(['Password is too short (minimum is 10 characters)', "Password #{message}"])
    end

    it 'should include: 1 uppercase, 1 lowercase, 1 digit and 1 special character' do
      @user.password = '1234567890'
      @user.password_confirmation = '1234567890'

      expect(@user.valid?).to be_falsey
      expect(@user.errors.messages[:password]).to eq([message])
    end

    it 'should include: 1 uppercase, 1 lowercase, 1 digit and 1 special character' do
      @user.password = 'abcdefghijkl'
      @user.password_confirmation = 'abcdefghijkl'

      expect(@user.valid?).to be_falsey
      expect(@user.errors.messages[:password]).to eq([message])
    end
  end
end
