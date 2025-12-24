# frozen_string_literal: true

module Api
  class BaseController < ActionController::API
    include Pagy::Backend
    include Devise::Controllers::Helpers
  end
end
