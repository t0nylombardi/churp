# frozen_string_literal: true

class View < ApplicationRecord
  after_create_commit {
    broadcast_prepend_to('view_churps', partial: 'churps/shared/analytics', locals: { churp: }, target: 'view-churps')
  }
  # validates_presence_of :ip_address

  belongs_to :user
  belongs_to :churp

  scope :by_user, lambda { |user, churp|
    where(user_id: user.id).where(churp_id: churp.id) unless user.role == :admin
  }
end
