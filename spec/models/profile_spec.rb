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
require 'rails_helper'

RSpec.describe Profile do
  let(:user) { build(:user) }

  describe '#create' do
    context 'when field attrs are valid' do
      it 'when first name is valid' do
        create(:profile, first_name: 'Rick')

        expect(described_class.last.first_name).to eq 'Rick'
      end

      it 'when last name is valid' do
        create(:profile, last_name: 'Sanchez')

        expect(described_class.last.last_name).to eq 'Sanchez'
      end

      it 'when description is valid' do
        create(:profile, description: 'I love tacos and tacos loves me')

        expect(described_class.last.description).to eq 'I love tacos and tacos loves me'
      end

      it 'when website is valid' do
        create(:profile, website: 'http://test.test.com')

        expect(described_class.last.website).to eq 'http://test.test.com'
      end
    end

    it 'errors on description for too many characters' do
      profile = build(:profile, description: Faker::Lorem.characters(number: 302), user:)

      expect(profile).to_not be_valid
      expect(profile.errors[:description]).to eq(['is too long (maximum is 300 characters)'])
    end

    it 'errors on webite for too many characters' do
      profile = build(:profile, website: Faker::Lorem.characters(number: 256), user:)

      expect(profile).to_not be_valid
      expect(profile.errors[:website]).to eq(['is too long (maximum is 255 characters)'])
    end
  end

  describe 'Upload profile_bg' do
    subject { create(:profile, user:).profile_bg }

    let(:image_path) { Rails.root.join('spec', 'fixtures', 'images') }
    let(:image_params) { { content_type: 'image/jpeg' } }
    let(:profile) { create(:profile, user:) }

    it { is_expected.to be_an_instance_of(ActiveStorage::Attached::One) }

    it 'is attached' do
      filename = 'stanley-roper-profile.png'
      file = File.open(Rails.root.join(image_path, filename))

      profile.profile_bg.attach(image_params.merge(io: file, filename:))
      expect(profile.profile_bg).to be_attached
      expect(profile).to be_valid
    end

    context 'with validations' do
      it 'errors on exceeding the file size' do
        filename = 'big_file.jpg'
        file = File.open(Rails.root.join(image_path, filename))

        profile.profile_bg.attach(image_params.merge(io: file, filename:))
        expect(profile.errors[:profile_bg]).to eq(['File is too big'])
      end

      it 'validates image type' do
        filename = 'wrong_file.txt'
        file = File.open(Rails.root.join(image_path, filename))

        profile.profile_bg.attach(image_params.merge(io: file, filename:, content_type: 'application/txt'))
        expect(profile.errors[:profile_bg]).to eq(['File must be a JPEG, JPG or PNG'])
      end
    end
  end

  describe 'Upload profile_pic' do
    subject { create(:profile, user:).profile_pic }

    let(:profile) { create(:profile, user:) }
    let(:params) do
      {
        io: File.open(Rails.root.join('spec', 'fixtures', 'images', 'stanley-roper-profile.png')),
        filename: 'stanley-roper-profile.png',
        content_type: 'image/png'
      }
    end

    it { is_expected.to be_an_instance_of(ActiveStorage::Attached::One) }

    it 'is attached' do
      profile.profile_pic.attach(params)

      expect(profile.profile_pic).to be_attached
      expect(profile).to be_valid
    end

    context 'with validations' do
      let(:image_path) { Rails.root.join('spec', 'fixtures', 'images') }
      let(:params) do
        {
          filename: 'stanley-roper-profile.png',
          content_type: 'image/png'
        }
      end

      it 'errors on exceeding the file size' do
        filename = 'big_file.jpg'
        file = File.open(Rails.root.join(image_path, filename))
        profile.profile_pic.attach(params.merge(io: file, filename:))

        expect(profile).to_not be_valid
        expect(profile.errors[:profile_pic]).to eq(['File is too big'])
      end

      it 'validates image type' do
        filename = 'wrong_file.txt'
        file = File.open(Rails.root.join(image_path, filename))
        profile.profile_pic.attach(params.merge(io: file, filename:, content_type: 'application/txt'))

        expect(profile.errors[:profile_pic]).to eq(['File must be a JPEG, JPG or PNG'])
      end
    end
  end
end
