# frozen_string_literal: true

module Middleware
  #
  # ::ViewPixel
  #
  class ViewPixel
    def initialize(app)
      @app = app
    end

    def call(env)
      @req = ::Rack::Request.new(env)
      if /view_pixel.png/.match?(@req.path_info)
        pixel if View.create!(params)
      else
        @app.call(env)
      end
    end

    private

    def params
      {
        user_id: user.id.to_s,
        churp_id: @req.params['churp'],
        ip_address:,
        city: location['city'],
        state: location['state_code'].split('-').last,
        user_agent: @req.user_agent
      }
    end

    def user
      @user = User.friendly.find(@req.params['user'])
    end

    def ip_address
      location['ip'] || @req.ip
    end

    def location
      Middleware::Services::Locations.new(@req.ip).call!
    end

    def pixel
      [
        200, { 'Content-Type' => 'image/png' },
        [File.read(File.join(File.dirname(__FILE__), 'images/view_pixel.png'))]
      ]
    end
  end
end
