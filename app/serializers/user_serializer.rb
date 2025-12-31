# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  display_name    :string
#  email           :string           default(""), not null
#  password_digest :string
#  role            :integer
#  slug            :string
#  username        :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_display_name  (display_name)
#  index_users_on_email         (email) UNIQUE
#  index_users_on_slug          (slug) UNIQUE
#  index_users_on_username      (username) UNIQUE
#
class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :username, :email, :created_at

  attribute :created_date do |user|
    user.created_at&.strftime("%m/%d/%Y")
  end
end
