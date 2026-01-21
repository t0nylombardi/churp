# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                  :uuid             not null, primary key
#  display_name        :string           default(""), not null
#  email               :string           default(""), not null
#  password_changed_at :datetime         not null
#  password_digest     :string           default(""), not null
#  role                :integer
#  slug                :string           default(""), not null
#  username            :string           default(""), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_users_on_email     (email) UNIQUE
#  index_users_on_username  (username) UNIQUE
#
class User < ApplicationRecord
  extend FriendlyId

  friendly_id :username, use: :slugged
  has_person_name
  has_secure_password

  # @return [String] the login identifier (username or email)
  attr_writer :login

  def login
    @login || username || email
  end

  def self.normalize_login(value)
    return value if value.include?("@") && value.include?(".")

    "@#{value}"
  end

  has_many :churps, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :churp_mentions, foreign_key: :mentioned_user_id, dependent: :destroy
  has_many :mentions, through: :churp_mentions, source: :churp

  has_many :notifications,
    as: :recipient,
    class_name: "Noticed::Notification",
    dependent: :destroy

  has_many :active_relationships,
    class_name: "Relationship",
    foreign_key: "follower_id",
    dependent: :destroy

  has_many :passive_relationships,
    class_name: "Relationship",
    foreign_key: "followed_id",
    dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_one :profile, dependent: :destroy

  searchkick highlight: [:username], word_middle: [:username]

  before_validation :assign_username, on: :create
  after_commit :reindex_users

  accepts_nested_attributes_for :profile

  validates :email, presence: true
  validates :email, uniqueness: true
  validates :password, presence: true
  validate :password_complexity, if: -> { password.present? }

  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id)&.destroy
  end

  def following?(other_user)
    following.exists?(other_user.id)
  end

  def unread_notifications
    notifications.unread
  end

  def normalize_friendly_id(value)
    value.to_s.downcase
  end

  private

  def reindex_users
    reindex
  end

  def assign_username
    result = Users::UsernameNormalizer.call(username:, email:)

    result.bind do |username|
      self.username = username.to_s
    end
  end

  def password_complexity
    regex = /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/
    return if password.match?(regex)

    errors.add :password, <<~MSG.squish
      Complexity requirement not met.
      Password must be 8–70 characters and include
      1 uppercase, 1 lowercase, 1 digit, and 1 special character.
    MSG
  end
end
