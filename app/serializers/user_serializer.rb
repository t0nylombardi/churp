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
class UserSerializer
  include JSONAPI::Serializer

  attributes :id, :username, :email, :created_at

  attribute :created_date do |user|
    user.created_at&.strftime("%m/%d/%Y")
  end
end
