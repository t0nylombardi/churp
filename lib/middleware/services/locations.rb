# frozen_string_literal: true

module Middleware
  module Services
    #
    # Locations
    #
    # param [string] ip_address
    #
    # Usage: Middleware::Services::Locations.new(<ip_address>).call
    #
    class Locations
      include ActiveModel::Validations
      attr_accessor :ip

      GEO_IP_URL = "https://api.ipgeolocation.io/ipgeo?"
      API_KEY = ENV.fetch("GEO_API_KEY", nil)

      def initialize(ip)
        @ip = ip
      end

      def call!
        raise ActiveModel::StrictValidationFailed unless valid?

        lookup!
      end

      private

      def lookup!
        @ip_address = Rails.env.production? ? ip : random_ip_address

        call_url
      end

      def geo_ip_url
        "#{GEO_IP_URL}apiKey=#{API_KEY}&ip=#{@ip_address}&fields=city,state_code&output=json"
      end

      def call_url
        HTTParty.get(geo_ip_url, timeout: 2)
      rescue Timeout::Error
        Rails.logger.warn("Could not post to ipgeolocation: timeout")
        { city: nil, state_code: nil }
      end

      def random_ip_address
        %w[ 104.156.54.182
          185.151.12.218
          185.151.12.226
          185.151.12.242
          107.181.191.68
          167.88.112.78
          209.135.132.136 ].sample
      end
    end
  end
end
