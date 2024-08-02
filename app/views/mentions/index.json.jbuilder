# frozen_string_literal: true

json.array! @mentions, partial: 'users/user', as: :user
