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
require 'rails_helper'

RSpec.describe Profile, type: :model do

  let(:user) { FactoryBot.build(:user) }

  describe '#create' do

    it 'is valid' do
      @profile = create(:profile,
                        first_name: 'Rick',
                        last_name: 'Sanchez',
                        description: 'I love tacos and tacos loves me',
                        website: 'http://test.test.com',
                        birth_date: '03/31/1983',
                        user:)

      expect(@profile.valid?).to be_truthy
      expect(@profile.first_name).to eq 'Rick'
      expect(@profile.last_name).to eq 'Sanchez'
      expect(@profile.description).to eq 'I love tacos and tacos loves me'
      expect(@profile.website).to eq 'http://test.test.com'
    end

    it 'errors on description for too many characters' do
      @profile = build(:profile, description: Faker::Lorem.characters(number: 302), user:)

      expect(@profile.valid?).to be_falsey
      expect(@profile.errors[:description]).to eq(['is too long (maximum is 300 characters)'])
    end

    it 'errors on webite for too many characters' do
      @profile = build(:profile, website: Faker::Lorem.characters(number: 256), user:)

      expect(@profile.valid?).to be_falsey
      expect(@profile.errors[:website]).to eq(['is too long (maximum is 255 characters)'])
    end
  end

  describe 'Upload profile_bg' do
    before(:each) do
      @profile = create(:profile, user:)
    end

    subject { create(:profile, user:).profile_bg }

    it { is_expected.to be_an_instance_of(ActiveStorage::Attached::One) }

    it 'is attached' do
      @profile.profile_bg.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'images', 'twitter_bg.jpeg')),
        filename: 'twitter_bg.jpeg',
        content_type: 'image/jpeg'
      )
      expect(@profile.profile_bg).to be_attached
      expect(@profile.valid?).to be_truthy
    end

    context 'validations' do

      it 'errors on exceeding the file size' do
        @profile.profile_bg.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'images', 'big_file.jpg')),
          filename: 'big_file.jpg',
          content_type: 'image/jpeg'
        )
        expect(@profile.valid?).to be_falsey
        expect(@profile.errors[:profile_bg]).to eq(['File is too big'])
      end

      it 'validates image type' do
        @profile.profile_bg.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'images', 'wrong_file.txt')),
          filename: 'wrong_file.txt',
          content_type: 'application/txt'
        )
        expect(@profile.valid?).to be_falsey
        expect(@profile.errors[:profile_bg]).to eq(['File must be a JPEG, JPG or PNG'])
      end
    end
  end

  describe 'Upload profile_pic' do
    before(:each) do
      @profile = create(:profile, user:)
    end

    subject { create(:profile, user:).profile_pic }

    it { is_expected.to be_an_instance_of(ActiveStorage::Attached::One) }

    it 'is attached' do
      @profile.profile_pic.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'images', 'stanley-roper-profile.png')),
        filename: 'stanley-roper-profile.png',
        content_type: 'image/png'
      )
      expect(@profile.profile_pic).to be_attached
      expect(@profile.valid?).to be_truthy
    end

    context 'validations' do

      it 'errors on exceeding the file size' do
        @profile.profile_pic.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'images', 'big_file.jpg')),
          filename: 'big_file.jpg',
          content_type: 'image/jpeg'
        )
        expect(@profile.valid?).to be_falsey
        expect(@profile.errors[:profile_pic]).to eq(['File is too big'])
      end

      it 'validates image type' do
        @profile.profile_pic.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'images', 'wrong_file.txt')),
          filename: 'wrong_file.txt',
          content_type: 'application/txt'
        )
        expect(@profile.valid?).to be_falsey
        expect(@profile.errors[:profile_pic]).to eq(['File must be a JPEG, JPG or PNG'])
      end
    end
  end

end
