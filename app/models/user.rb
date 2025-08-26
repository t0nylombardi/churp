# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  display_name           :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer
#  sign_in_count          :integer          default(0), not null
#  slug                   :string
#  unconfirmed_email      :string
#  unlock_token           :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_display_name          (display_name)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_slug                  (slug) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  include ActionText::Attachable
  extend FriendlyId
  friendly_id :username, use: :slugged
  has_person_name

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_many :churps, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy

  has_many :active_relationships, dependent: :destroy,
    class_name: "Relationship",
    foreign_key: "follower_id"

  has_many :passive_relationships, dependent: :destroy,
    class_name: "Relationship",
    foreign_key: "followed_id"

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_one :profile, dependent: :destroy

  searchkick highlight: [:username], word_middle: [:username]

  accepts_nested_attributes_for :profile

  validates :username, :email, :password, presence: true
  validates :username, uniqueness: true
  validates :email, uniqueness: true
  validate :password_complexity

  before_commit on: :create do
    self.username = "@#{username.downcase}" unless username.start_with?("@")
  end

  def normalize_friendly_id(value)
    value.to_s.downcase
  end

  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  def unread_notifications
    notifications.unread
  end

  private

  after_commit :reindex_users
  def reindex_users
    reindex
  end

  def password_complexity
    message = <<-TEXT.gsub(/\s+/, " ").strip
    Complexity requirement not met. Length should be 8-128 characters and
    include: 1 uppercase, 1 lowercase, 1 digit and 1 special character
    TEXT

    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/

    errors.add :password, message
  end
end
