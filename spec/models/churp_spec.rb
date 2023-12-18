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
require 'rails_helper'

RSpec.describe Churp do
  describe '#create' do
    let(:user) { create(:user) }
    let(:churp) { create(:churp, user:) }
    let(:params) do
      {
        io: File.open(Rails.root.join('spec', 'fixtures', 'images', 'wrong_file.txt')),
        filename: 'wrong_file.txt',
        content_type: 'application/txt'
      }
    end

    it 'does not accept no characters in body' do
      churp.content = ''

      expect(churp).to_not be_valid
      expect(churp.errors.messages[:body]).to eq(['is too short (minimum is 1 character)'])
    end

    it 'does not accept too many characters in body' do
      churp.conent = Faker::Lorem.paragraph_by_chars(number: 332)

      expect(churp).to_not be_valid
      expect(churp.errors.messages[:body]).to eq(['is too long (maximum is 331 characters)'])
    end

    it 'does not accept with out a user' do
      churp.user = nil

      expect(churp).to_not be_valid
      expect(churp.errors.messages[:user]).to eq(['must exist'])
    end

    context 'with attached media' do
      it 'is valid if image is attached' do
        churp = create(:churp, :with_attachment)
        expect(churp.valid?).to be true
      end

      it 'does not accept any file that is not png or jpeg' do
        churp.churp_pic.attach(params)
        expect(churp).to_not be_valid
        expect(churp.errors[:churp_pic]).to eq(['File must be a JPEG, JPG or PNG'])
      end
    end
  end
end
