# frozen_string_literal: true

module Seed
  class AdminSeeder
    Result = Struct.new(:success?, :user, :error_message)

    def call
      return Result.new(false, nil, "Admin already exists") if admin_exists?

      user = create_admin_user
      create_admin_profile(user)

      Result.new(true, user, nil)
    rescue => e
      Rails.logger.error "[Seed::Admin] Error: #{e.message}"
      Result.new(false, nil, e.message)
    end

    private

    def admin_exists?
      User.exists?(role: "admin")
    end

    def create_admin_user
      User.create!(
        email: "admin@churp.com",
        password: "Passw0rd1!",
        password_confirmation: "Passw0rd1!",
        username: "t0nylombardi",
        role: "admin"
      )
    end

    def create_admin_profile(user)
      user.create_profile!(
        first_name: "Anthony",
        last_name: "Lombardi",
        description: "I like Tacos and Tacos like me",
        website: "https://t0nylombardi.dev",
        birth_date: Date.new(1983, 3, 31)
      )
    end
  end
end
