require 'rails_helper'

RSpec.describe Tweet, type: :model do
  describe '#create' do
    let(:user) { create(:user) }
    let(:tweet) { create(:tweet, user:) }

    it 'should not accept no characters in body' do
      tweet.body = ''

      expect(tweet.valid?).to be_falsey
      expect(tweet.errors.messages[:body]).to eq(['is too short (minimum is 1 character)'])
    end

    it 'should not accept too many characters in body' do
      tweet.body = Faker::Lorem.paragraph_by_chars(number: 332)

      expect(tweet.valid?).to be_falsey
      expect(tweet.errors.messages[:body]).to eq(['is too long (maximum is 331 characters)'])
    end

    it 'should not accept with out a user' do
      tweet.user = nil

      expect(tweet.valid?).to be_falsey
      expect(tweet.errors.messages[:user]).to eq(['must exist'])
    end

    context 'attached media' do
      it 'is valid if image is attached' do
        tweet = create(:tweet, :with_attachment)
        expect(tweet.valid?).to eq true
      end

      it 'should not accept any file that is not png or jpeg ' do
        tweet.churp_pic.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'images', 'wrong_file.txt')),
          filename: 'wrong_file.txt',
          content_type: 'application/txt'
        )
        expect(tweet.valid?).to be_falsey
        expect(tweet.errors[:churp_pic]).to eq(['File must be a JPEG, JPG or PNG'])
      end
    end

  end

end
