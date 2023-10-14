# frozen_string_literal: true

class User < ApplicationRecord
  extend FriendlyId
  friendly_id :username, use: :slugged
  has_person_name

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tweets, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one :profile, dependent: :destroy

  accepts_nested_attributes_for :profile

end
