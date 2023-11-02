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

RSpec.describe Churp, type: :model do
  describe '#create' do
    let(:user) { create(:user) }
    let(:churp) { create(:churp, user:) }

    it 'should not accept no characters in body' do
      churp.body = ''

      expect(churp.valid?).to be_falsey
      expect(churp.errors.messages[:body]).to eq(['is too short (minimum is 1 character)'])
    end

    it 'should not accept too many characters in body' do
      churp.body = Faker::Lorem.paragraph_by_chars(number: 332)

      expect(churp.valid?).to be_falsey
      expect(churp.errors.messages[:body]).to eq(['is too long (maximum is 331 characters)'])
    end

    it 'should not accept with out a user' do
      churp.user = nil

      expect(churp.valid?).to be_falsey
      expect(churp.errors.messages[:user]).to eq(['must exist'])
    end

    context 'attached media' do
      it 'is valid if image is attached' do
        churp = create(:churp, :with_attachment)
        expect(churp.valid?).to eq true
      end

      it 'should not accept any file that is not png or jpeg ' do
        churp.churp_pic.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'images', 'wrong_file.txt')),
          filename: 'wrong_file.txt',
          content_type: 'application/txt'
        )
        expect(churp.valid?).to be_falsey
        expect(churp.errors[:churp_pic]).to eq(['File must be a JPEG, JPG or PNG'])
      end
    end

  end

end
