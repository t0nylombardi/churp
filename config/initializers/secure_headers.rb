# frozen_string_literal: true

Rails.application.config.ssl_options = {
  hsts: { max_age: 31536000, includeSubDomains: true, preload: true }
}
