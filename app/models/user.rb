# frozen_string_literal: true

class User < ApplicationRecord
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
  has_one :profile, dependent: :destroy

  accepts_nested_attributes_for :profile

  validates :username, :email, :password, presence: true
  validates :username, :email, uniqueness: true
  validate :password_complexity

  private

  def password_complexity
    message = <<-TEXT.gsub(/\s+/, ' ').strip
    Complexity requirement not met. Length should be 8-128 characters and
    include: 1 uppercase, 1 lowercase, 1 digit and 1 special character
    TEXT

    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,70}$/

    errors.add :password, message
  end
end
