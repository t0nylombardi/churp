# frozen_string_literal: true

require "support/helpers/auth_helper"

RSpec.configure do |config|
  config.include AuthHelper, type: :request
end
