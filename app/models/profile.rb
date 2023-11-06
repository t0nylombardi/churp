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
class Profile < ApplicationRecord
  has_person_name

  has_one_attached :profile_pic do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200]
  end
  has_one_attached :profile_bg

  belongs_to :user

  validates :name, presence: true, length: { minimum: 3 }
  validates :description, length: { maximum: 300 }
  validates :website, length: { maximum: 255 }

  validates :profile_pic, acceptable_image: true
  validates :profile_bg, acceptable_image: true
end
