class Profile < ApplicationRecord
  has_person_name
  
  has_one_attached :profile_pic do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200]
  end
  has_one_attached :profile_bg

  belongs_to :user

  validates_length_of :description, maximum: 300
  validates_length_of :website, maximum: 255

  validates :profile_pic, acceptable_image: true
  validates :profile_bg, acceptable_image: true

end
