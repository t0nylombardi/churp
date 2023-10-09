class Profile < ApplicationRecord
  has_person_name
  
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200]
  end

  belongs_to :user

  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :description, length: { maximum: 300 }
end