class Comment < ApplicationRecord
  belongs_to :tweet
  belongs_to :user

  scope :recent_comments, -> { order('created_at DESC') }
end
