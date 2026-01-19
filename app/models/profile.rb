# frozen_string_literal: true

# == Schema Information
#
# Table name: profiles
#
#  id          :uuid             not null, primary key
#  avatar      :jsonb            not null
#  birth_date  :datetime
#  cover       :jsonb            not null
#  description :text
#  first_name  :string
#  last_name   :string
#  theme       :integer          default(0)
#  theme_color :integer          default(0)
#  website     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :uuid             not null
#
# Indexes
#
#  index_profiles_on_avatar   (avatar) USING gin
#  index_profiles_on_cover    (cover) USING gin
#  index_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Profile < ApplicationRecord
  has_person_name
  searchkick word_middle: %i[first_name last_name]

  belongs_to :user

  validates :name, presence: true, length: { minimum: 3 }
  validates :description, length: { maximum: 300 }
  validates :website, length: { maximum: 255 }

  # validates :avatar, acceptable_image: true
  # validates :cover, acceptable_image: true

  def full_name
    "#{first_name} #{last_name}".strip
  end

  private

  after_commit :reindex_profiles
  def reindex_profiles
    reindex
  end

  # before_commit :create_default_avatar, on: :create
  # def create_default_avatar
  #   nil if profile_pic.attached?
  # end
end
