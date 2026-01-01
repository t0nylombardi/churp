# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  include ActiveStorage::SetCurrent

  before_action :set_hash_tags

  def set_hash_tags
    @popular_hashtags = HashTag.top_three
  end
end
