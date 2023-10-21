# frozen_string_literal: true

class AssumeSSL
  def initialize(app)
    @app = app
  end

  def call(env)
    env['HTTPS'] = 'on'
    env['HTTP_X_FORWARDED_PORT'] = 443
    env['HTTP_X_FORWARDED_PROTO'] = 'https'
    env['rack.url_scheme'] = 'https'

    @app.call(env)
  end
end

# config/application.rb
#
Dir[Rails.root.join('lib/middleware/**/*.{rb}')].sort
                                                .each { |file| require file }

# config/environments/production.rb
#
Rails.application.config.middleware.insert_before(0, AssumeSSL)
